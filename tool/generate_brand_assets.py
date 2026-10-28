from collections import deque
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parents[1]
SOURCE_ICON = ROOT / "assets" / "icon.png"
SOURCE_SPLASH = ROOT / "assets" / "Splash Screen.png"
OUT = ROOT / "assets" / "brand"
PREVIEW = Path("/tmp/opencode/sertech_brand_preview.png")

LIGHT_BG = (247, 250, 245, 255)
DARK_BG = (7, 17, 12, 255)
WHITE = (255, 255, 255, 255)


def background_mask(image: Image.Image, threshold: int = 242) -> bytearray:
    rgb = image.convert("RGB")
    width, height = rgb.size
    pixels = rgb.load()
    mask = bytearray(width * height)
    queue: deque[int] = deque()

    def is_white(x: int, y: int) -> bool:
        r, g, b = pixels[x, y]
        return r >= threshold and g >= threshold and b >= threshold

    for x in range(width):
        for y in (0, height - 1):
            index = y * width + x
            if not mask[index] and is_white(x, y):
                mask[index] = 1
                queue.append(index)
    for y in range(height):
        for x in (0, width - 1):
            index = y * width + x
            if not mask[index] and is_white(x, y):
                mask[index] = 1
                queue.append(index)

    while queue:
        index = queue.popleft()
        x = index % width
        y = index // width

        if x > 0:
            neighbour = index - 1
            if not mask[neighbour] and is_white(x - 1, y):
                mask[neighbour] = 1
                queue.append(neighbour)
        if x + 1 < width:
            neighbour = index + 1
            if not mask[neighbour] and is_white(x + 1, y):
                mask[neighbour] = 1
                queue.append(neighbour)
        if y > 0:
            neighbour = index - width
            if not mask[neighbour] and is_white(x, y - 1):
                mask[neighbour] = 1
                queue.append(neighbour)
        if y + 1 < height:
            neighbour = index + width
            if not mask[neighbour] and is_white(x, y + 1):
                mask[neighbour] = 1
                queue.append(neighbour)

    return mask


def cutout(path: Path) -> Image.Image:
    source = Image.open(path).convert("RGB")
    mask = background_mask(source)
    alpha = Image.new("L", source.size)
    alpha.putdata([0 if value else 255 for value in mask])
    alpha = alpha.filter(ImageFilter.MinFilter(3))
    alpha = alpha.filter(ImageFilter.GaussianBlur(0.45))
    cut = source.convert("RGBA")
    cut.putalpha(alpha)
    bbox = cut.getchannel("A").getbbox()
    if bbox is None:
        raise ValueError(f"Aucun contenu détecté dans {path}")
    return cut.crop(bbox)


def fit(mark: Image.Image, size: int, ratio: float) -> Image.Image:
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    target = int(round(size * ratio))
    scale = min(target / mark.width, target / mark.height)
    resized = mark.resize(
        (max(1, int(round(mark.width * scale))), max(1, int(round(mark.height * scale)))),
        Image.Resampling.LANCZOS,
    )
    canvas.alpha_composite(
        resized,
        ((size - resized.width) // 2, (size - resized.height) // 2),
    )
    return canvas


def rounded_mask(size: int, radius: int) -> Image.Image:
    mask = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.rounded_rectangle((0, 0, size - 1, size - 1), radius=radius, fill=255)
    return mask


def splash_light(path: Path) -> Image.Image:
    source = Image.open(path).convert("RGB")
    return source.resize((768, 768), Image.Resampling.LANCZOS).convert("RGBA")


def splash_dark(path: Path) -> Image.Image:
    canvas = Image.new("RGBA", (768, 768), DARK_BG)
    card_size = 640
    card_radius = 64
    card_origin = ((768 - card_size) // 2, (768 - card_size) // 2)

    shadow = Image.new("RGBA", (768, 768), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    shadow_draw.rounded_rectangle(
        (
            card_origin[0],
            card_origin[1] + 14,
            card_origin[0] + card_size,
            card_origin[1] + card_size + 14,
        ),
        radius=card_radius,
        fill=(0, 0, 0, 120),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(26))
    canvas.alpha_composite(shadow)

    card = Image.new("RGBA", (card_size, card_size), (0, 0, 0, 0))
    card_draw = ImageDraw.Draw(card)
    card_draw.rounded_rectangle(
        (0, 0, card_size - 1, card_size - 1),
        radius=card_radius,
        fill=WHITE,
    )
    art = Image.open(path).convert("RGB").resize(
        (card_size, card_size),
        Image.Resampling.LANCZOS,
    )
    art = art.convert("RGBA")
    art.putalpha(rounded_mask(card_size, card_radius))
    card.alpha_composite(art)
    canvas.alpha_composite(card, card_origin)
    return canvas


def monochrome(mark: Image.Image, size: int) -> Image.Image:
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    target = int(round(size * 0.92))
    scale = min(target / mark.width, target / mark.height)
    resized = mark.resize(
        (max(1, int(round(mark.width * scale))), max(1, int(round(mark.height * scale)))),
        Image.Resampling.LANCZOS,
    )
    silhouette = Image.new("RGBA", resized.size, WHITE)
    silhouette.putalpha(resized.getchannel("A"))
    canvas.alpha_composite(
        silhouette,
        ((size - resized.width) // 2, (size - resized.height) // 2),
    )
    return canvas


def label_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    candidates = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation2/LiberationSans-Regular.ttf",
    ]
    for candidate in candidates:
        if Path(candidate).exists():
            return ImageFont.truetype(candidate, size)
    return ImageFont.load_default()


def preview(
    mark: Image.Image,
    foreground: Image.Image,
    mono: Image.Image,
    light: Image.Image,
    dark: Image.Image,
    android12: Image.Image,
) -> None:
    canvas = Image.new("RGBA", (1800, 1200), LIGHT_BG)
    draw = ImageDraw.Draw(canvas)
    title = label_font(34)
    body = label_font(22)

    canvas.paste(DARK_BG, (0, 600, 1800, 1200))
    draw.text((90, 42), "SERTECH — APERÇU DES ACTIFS", font=title, fill=(19, 37, 26, 255))
    draw.text((90, 84), "Clair", font=body, fill=(91, 107, 97, 255))
    draw.text((90, 642), "Sombre", font=body, fill=(168, 184, 174, 255))

    def sample(image: Image.Image, box: tuple[int, int, int, int], background: tuple[int, int, int, int]) -> None:
        card = Image.new("RGBA", (box[2] - box[0], box[3] - box[1]), background)
        fitted = fit(image, min(card.width, card.height) - 36, 0.86)
        card.alpha_composite(
            fitted,
            ((card.width - fitted.width) // 2, (card.height - fitted.height) // 2),
        )
        canvas.alpha_composite(card, (box[0], box[1]))

    sample(mark, (90, 150, 390, 450), (255, 255, 255, 255))
    sample(android12, (450, 150, 750, 450), (255, 255, 255, 255))
    sample(light, (810, 120, 1230, 540), (255, 255, 255, 255))
    sample(dark, (1290, 90, 1710, 510), DARK_BG)

    sample(mark, (90, 750, 390, 1050), (14, 26, 19, 255))
    sample(mono, (450, 750, 750, 1050), (14, 26, 19, 255))
    sample(dark, (810, 690, 1230, 1110), DARK_BG)
    sample(android12, (1290, 750, 1590, 1050), DARK_BG)
    sample(foreground, (1620, 750, 1740, 870), (255, 255, 255, 255))

    draw.text((90, 462), "Marque", font=body, fill=(91, 107, 97, 255))
    draw.text((450, 462), "Icône adaptative", font=body, fill=(91, 107, 97, 255))
    draw.text((810, 552), "Splash clair", font=body, fill=(91, 107, 97, 255))
    draw.text((1290, 522), "Splash sombre", font=body, fill=(91, 107, 97, 255))
    draw.text((90, 1062), "Marque sur sombre", font=body, fill=(168, 184, 174, 255))
    draw.text((450, 1062), "Monochrome", font=body, fill=(168, 184, 174, 255))
    draw.text((810, 1122), "Carte splash", font=body, fill=(168, 184, 174, 255))
    draw.text((1290, 1062), "Android 12", font=body, fill=(168, 184, 174, 255))

    PREVIEW.parent.mkdir(parents=True, exist_ok=True)
    canvas.convert("RGB").save(PREVIEW, quality=95)


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    mark = cutout(SOURCE_ICON)
    mark_asset = fit(mark, 512, 0.88)
    foreground = fit(mark, 1024, 0.96)
    mono = monochrome(mark, 1024)
    light = splash_light(SOURCE_SPLASH)
    dark = splash_dark(SOURCE_SPLASH)
    android12 = fit(mark, 960, 0.625)

    mark_asset.save(OUT / "sertech_mark.png", optimize=True)
    foreground.save(OUT / "icon_foreground.png", optimize=True)
    mono.save(OUT / "icon_monochrome.png", optimize=True)
    light.save(OUT / "splash_light.png", optimize=True)
    dark.save(OUT / "splash_dark.png", optimize=True)
    android12.save(OUT / "splash_android12.png", optimize=True)
    preview(mark_asset, foreground, mono, light, dark, android12)


if __name__ == "__main__":
    main()
