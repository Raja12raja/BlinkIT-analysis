UPDATE blinkit_sales 
SET item_fat_content = CASE
    WHEN LOWER(TRIM(item_fat_content)) = 'low fat' THEN 'Low Fat'
    WHEN TRIM(item_fat_content) = 'LF' THEN 'Low Fat'
    WHEN LOWER(TRIM(item_fat_content)) = 'regular' THEN 'Regular'
    WHEN LOWER(TRIM(item_fat_content)) = 'reg' THEN 'Regular'
    ELSE TRIM(item_fat_content)
END;

SELECT COUNT(*) FROM blinkit_sales;
SELECT * FROM blinkit_sales where item_fat_content='Item Fat Content' order by item_fat_content desc;
DELETE FROM blinkit_sales WHERE item_fat_content = 'Item Fat Content';

SELECT item_fat_content, COUNT(*) as count
FROM blinkit_sales 
GROUP BY item_fat_content 
ORDER BY count DESC;

UPDATE blinkit_sales 
SET outlet_size = CASE
    WHEN TRIM(outlet_size) = 'High' THEN 'Large'
    WHEN TRIM(outlet_size) = 'Medium' THEN 'Medium'
    WHEN TRIM(outlet_size) = 'Small' THEN 'Small'
    ELSE TRIM(outlet_size)
END;

SELECT outlet_size, COUNT(*) as count
FROM blinkit_sales 
GROUP BY outlet_size 
ORDER BY count DESC;

SELECT outlet_location_type, COUNT(*) as count
FROM blinkit_sales 
GROUP BY outlet_location_type 
ORDER BY count DESC;

UPDATE blinkit_sales 
SET item_weight = (
    SELECT AVG(item_weight) 
    FROM blinkit_sales s2 
    WHERE s2.item_weight IS NOT NULL 
    AND s2.item_type = blinkit_sales.item_type
)
WHERE item_weight IS NULL;

SELECT 
    SUM(CASE WHEN item_fat_content IS NULL THEN 1 ELSE 0 END) as missing_fat_content,
    SUM(CASE WHEN sales IS NULL THEN 1 ELSE 0 END) as missing_sales,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) as missing_ratings,
    SUM(CASE WHEN item_weight IS NULL THEN 1 ELSE 0 END) as missing_weight
FROM blinkit_sales;

ALTER TABLE blinkit_sales
ALTER COLUMN item_visibility TYPE numeric(10,8) USING item_visibility::numeric,
ALTER COLUMN item_weight TYPE numeric(10,2) USING item_weight::numeric,
ALTER COLUMN sales TYPE numeric(10,4) USING sales::numeric,
ALTER COLUMN rating TYPE integer USING rating::integer;


SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT item_identifier) as unique_items,
    COUNT(DISTINCT outlet_identifier) as unique_outlets,
    MIN(sales) as min_sales,
    MAX(sales) as max_sales,
    AVG(sales) as avg_sales,
    MIN(rating) as min_rating,
    MAX(rating) as max_rating,
    AVG(rating) as avg_rating
FROM blinkit_sales;

CREATE TABLE data_cleaning_summary AS
SELECT 
    'Data Cleaning Summary' as metric,
    COUNT(*) as value,
    'Total records processed' as description
FROM blinkit_sales
UNION ALL
SELECT 
    'Unique Items',
    COUNT(DISTINCT item_identifier),
    'Number of unique items'
FROM blinkit_sales
UNION ALL
SELECT 
    'Unique Outlets',
    COUNT(DISTINCT outlet_identifier),
    'Number of unique outlets'
FROM blinkit_sales
UNION ALL
SELECT 
    'Item Types',
    COUNT(DISTINCT item_type),
    'Number of different item types'
FROM blinkit_sales
UNION ALL
SELECT 
    'Outlet Types',
    COUNT(DISTINCT outlet_type),
    'Number of different outlet types'
FROM blinkit_sales;