SELECT
    policyname,
    roles,
    cmd,
    with_check,
    qual
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename = 'sensor_data';