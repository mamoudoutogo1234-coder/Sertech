
import os
import time
import random
import logging
from datetime import datetime, timezone
from pathlib import Path

from dotenv import load_dotenv
from supabase import create_client


# ============================================================
# CONFIGURATION
# ============================================================

BASE_DIR = Path(__file__).resolve().parent
load_dotenv(BASE_DIR / ".env")

SUPABASE_URL = os.getenv(
    "SUPABASE_URL",
    "http://127.0.0.1:54321",
).rstrip("/")

SUPABASE_KEY = os.getenv("SUPABASE_PUBLISHABLE_KEY", "")
ZONE_ID = os.getenv("SERTECH_ZONE_ID", "")

INTERVAL_SECONDS = 1.0

# Plage d'humidité simulée
MIN_MOISTURE = 15.0
MAX_MOISTURE = 80.0

# Simulation ADC ESP32 sur 12 bits
ADC_MAX = 4095

# Logs
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger("sertech-simulator")


# ============================================================
# INITIALISATION
# ============================================================

def create_supabase_client():
    """Initialise le client Supabase depuis le fichier .env."""

    if not SUPABASE_KEY:
        raise ValueError(
            "SUPABASE_PUBLISHABLE_KEY est absent du fichier .env"
        )

    if not ZONE_ID:
        raise ValueError(
            "SERTECH_ZONE_ID est absent du fichier .env"
        )

    client = create_client(SUPABASE_URL, SUPABASE_KEY)

    logger.info("Supabase URL : %s", SUPABASE_URL)
    logger.info("Zone ciblée : %s", ZONE_ID)

    return client


# ============================================================
# SIMULATION FC-28
# ============================================================

def moisture_to_raw(moisture_percent: float) -> int:
    """
    Simule une valeur ADC de 0 à 4095.

    Hypothèse de simulation :
    ADC élevé = sol sec.
    La calibration physique du FC-28 peut être différente.
    """

    moisture_percent = max(
        0.0,
        min(100.0, moisture_percent),
    )

    raw = ADC_MAX * (1.0 - moisture_percent / 100.0)

    return round(max(0, min(ADC_MAX, raw)))


def generate_reading(previous_moisture: float) -> dict:
    """Génère une mesure d'humidité légèrement variable."""

    variation = random.uniform(-0.6, 0.6)

    moisture = previous_moisture + variation
    moisture = max(
        MIN_MOISTURE,
        min(MAX_MOISTURE, moisture),
    )

    return {
        "zone_id": ZONE_ID,
        "recorded_at": datetime.now(timezone.utc).isoformat(),
        "moisture_raw": moisture_to_raw(moisture),
        "moisture_percent": round(moisture, 2),
        "source": "simulator",
        "metadata": {
            "device": "python_sensor_simulator",
            "sensor": "FC-28",
            "adc_resolution": 12,
            "simulated": True,
        },
    }


# ============================================================
# INSERTION DANS SENSOR_DATA
# ============================================================

def insert_reading(client, reading: dict) -> bool:
    """
    Insère une ligne dans public.sensor_data.

    Chaque INSERT autorisé peut produire un événement
    PostgreSQL Realtime pour les clients abonnés.
    """

    try:
        client.table("sensor_data").insert(reading).execute()

        logger.info(
            "INSERT OK | humidité=%s%% | ADC=%s | source=%s",
            reading["moisture_percent"],
            reading["moisture_raw"],
            reading["source"],
        )

        return True

    except Exception as exc:
        logger.error("Échec insertion sensor_data : %s", exc)
        return False


# ============================================================
# BOUCLE DE SIMULATION
# ============================================================

def run_simulator():
    client = create_supabase_client()

    moisture = random.uniform(35.0, 55.0)
    successful = 0
    failed = 0

    logger.info("=== SERTECH SENSOR SIMULATOR ===")
    logger.info("Table : public.sensor_data")
    logger.info("Fréquence : 1 mesure/seconde")
    logger.info("Arrêt : Ctrl+C")

    try:
        while True:
            start = time.monotonic()

            reading = generate_reading(moisture)

            # Maintient la continuité de la simulation
            moisture = reading["moisture_percent"]

            if insert_reading(client, reading):
                successful += 1
            else:
                failed += 1

            elapsed = time.monotonic() - start
            time.sleep(max(0.0, INTERVAL_SECONDS - elapsed))

    except KeyboardInterrupt:
        logger.info("Arrêt demandé par l'utilisateur.")

    finally:
        logger.info(
            "Bilan | insertions réussies=%s | échecs=%s",
            successful,
            failed,
        )


if __name__ == "__main__":
    try:
        run_simulator()
    except (ValueError, Exception) as exc:
        logger.error("Impossible de démarrer le simulateur : %s", exc)
        raise SystemExit(1)
