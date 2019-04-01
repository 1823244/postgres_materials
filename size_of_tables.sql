

SELECT
	TABLE_NAME,
	pg_size_pretty(pg_table_size(TABLE_NAME)) AS table_size,
	pg_size_pretty(pg_indexes_size(TABLE_NAME)) AS indexes_size,
	pg_size_pretty(pg_total_relation_size(TABLE_NAME)) AS total_size,
	pg_total_relation_size(TABLE_NAME) AS total_size_sort
FROM (
	SELECT ('"' || table_schema || '"."' || TABLE_NAME || '"') AS TABLE_NAME
	FROM information_schema.tables
	WHERE table_catalog = 'testDB01' 	-- bd name
	--AND table_schema = 'public'			-- user's tables
) AS all_tables
ORDER BY total_size_sort DESC
