-- Enable Realtime for sensor_data
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND schemaname = 'public'
      AND tablename = 'sensor_data'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.sensor_data;
  END IF;
END $$;
