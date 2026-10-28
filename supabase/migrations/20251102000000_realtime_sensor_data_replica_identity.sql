-- Ensure Realtime can send full row changes for sensor_data
ALTER TABLE public.sensor_data REPLICA IDENTITY FULL;

-- Ensure table is in publication (idempotent)
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
