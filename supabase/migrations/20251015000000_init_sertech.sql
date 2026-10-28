-- Sertech initial schema (local Supabase)
-- 5 tables, no devices table

CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- profiles
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name text,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- zones
CREATE TABLE IF NOT EXISTS zones (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  is_active boolean NOT NULL DEFAULT true,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_zones_user_id ON zones(user_id);

-- sensor_data
CREATE TABLE IF NOT EXISTS sensor_data (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  zone_id uuid NOT NULL REFERENCES zones(id) ON DELETE CASCADE,
  recorded_at timestamptz NOT NULL DEFAULT now(),
  moisture_raw numeric,
  moisture_percent numeric,
  source text,
  metadata jsonb,
  CONSTRAINT chk_moisture_raw_non_neg CHECK (moisture_raw IS NULL OR moisture_raw >= 0),
  CONSTRAINT chk_moisture_percent_range CHECK (moisture_percent IS NULL OR (moisture_percent >= 0 AND moisture_percent <= 100))
);
CREATE INDEX IF NOT EXISTS idx_sensor_data_zone_id_recorded_at ON sensor_data(zone_id, recorded_at DESC);

-- irrigation_settings
CREATE TABLE IF NOT EXISTS irrigation_settings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  zone_id uuid NOT NULL UNIQUE REFERENCES zones(id) ON DELETE CASCADE,
  auto_enabled boolean NOT NULL DEFAULT false,
  start_threshold numeric NOT NULL,
  stop_threshold numeric NOT NULL,
  max_duration_seconds integer NOT NULL,
  min_interval_seconds integer NOT NULL,
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT chk_hysteresis CHECK (start_threshold <= stop_threshold),
  CONSTRAINT chk_durations CHECK (max_duration_seconds > 0 AND min_interval_seconds >= 0)
);

-- valve_commands
CREATE TABLE IF NOT EXISTS valve_commands (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  zone_id uuid NOT NULL REFERENCES zones(id) ON DELETE CASCADE,
  type text NOT NULL CHECK (type IN ('open','close')),
  status text NOT NULL CHECK (status IN ('pending','executing','executed','failed')),
  origin text,
  reason text,
  requested_at timestamptz NOT NULL DEFAULT now(),
  executed_at timestamptz,
  error_message text
);
CREATE INDEX IF NOT EXISTS idx_valve_commands_zone_id_requested_at ON valve_commands(zone_id, requested_at DESC);
CREATE INDEX IF NOT EXISTS idx_valve_commands_status ON valve_commands(status);

-- updated_at trigger
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_zones_updated_at
BEFORE UPDATE ON zones
FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

CREATE TRIGGER trg_irrigation_settings_updated_at
BEFORE UPDATE ON irrigation_settings
FOR EACH ROW EXECUTE PROCEDURE set_updated_at();

-- RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE sensor_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE irrigation_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE valve_commands ENABLE ROW LEVEL SECURITY;

CREATE POLICY profiles_select_own ON profiles FOR SELECT USING (auth.uid() = id);
CREATE POLICY profiles_insert_own ON profiles FOR INSERT WITH CHECK (auth.uid() = id);
CREATE POLICY profiles_update_own ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY zones_select_own ON zones FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY zones_insert_own ON zones FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY zones_update_own ON zones FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY zones_delete_own ON zones FOR DELETE USING (auth.uid() = user_id);

CREATE POLICY sensor_data_select_own ON sensor_data FOR SELECT
  USING (EXISTS (SELECT 1 FROM zones z WHERE z.id = sensor_data.zone_id AND z.user_id = auth.uid()));
CREATE POLICY sensor_data_insert_own ON sensor_data FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM zones z WHERE z.id = sensor_data.zone_id AND z.user_id = auth.uid()));

CREATE POLICY irrigation_settings_select_own ON irrigation_settings FOR SELECT
  USING (EXISTS (SELECT 1 FROM zones z WHERE z.id = irrigation_settings.zone_id AND z.user_id = auth.uid()));
CREATE POLICY irrigation_settings_insert_own ON irrigation_settings FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM zones z WHERE z.id = irrigation_settings.zone_id AND z.user_id = auth.uid()));
CREATE POLICY irrigation_settings_update_own ON irrigation_settings FOR UPDATE
  USING (EXISTS (SELECT 1 FROM zones z WHERE z.id = irrigation_settings.zone_id AND z.user_id = auth.uid()));

CREATE POLICY valve_commands_select_own ON valve_commands FOR SELECT
  USING (EXISTS (SELECT 1 FROM zones z WHERE z.id = valve_commands.zone_id AND z.user_id = auth.uid()));
CREATE POLICY valve_commands_insert_own ON valve_commands FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM zones z WHERE z.id = valve_commands.zone_id AND z.user_id = auth.uid()));
