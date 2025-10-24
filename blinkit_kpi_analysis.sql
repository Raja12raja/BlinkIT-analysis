-- ================================================
-- 🛠️ BLINKIT GROCERY SALES KPI ANALYSIS
-- ================================================
-- A. KEY PERFORMANCE INDICATORS (KPIs)
-- ================================================

-- A.1 Total Sales (in millions)
CREATE TABLE total_sales_million AS
SELECT CAST(SUM(sales) / 1000000.0 AS DECIMAL(10,2)) AS Total_Sales_Million
FROM blinkit_sales;

-- A.2 Average Sales
CREATE TABLE avg_sales AS
SELECT CAST(AVG(sales) AS INT) AS Avg_Sales
FROM blinkit_sales;

-- A.3 Number of Items
CREATE TABLE no_of_items AS
SELECT COUNT(*) AS No_of_Orders
FROM blinkit_sales;

-- A.4 Average Rating
CREATE TABLE avg_rating AS
SELECT CAST(AVG(rating) AS DECIMAL(10,1)) AS Avg_Rating
FROM blinkit_sales;

-- ================================================
-- B. SALES DISTRIBUTION ANALYSIS
-- ================================================

-- B.1 Total Sales by Fat Content
CREATE TABLE sales_by_fat_content AS
SELECT 
    item_fat_content AS Item_Fat_Content, 
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_sales
GROUP BY item_fat_content;

-- B.2 Total Sales by Item Type
CREATE TABLE sales_by_item_type AS
SELECT 
    item_type AS Item_Type, 
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_sales
GROUP BY item_type
ORDER BY Total_Sales DESC;

-- B.3 Fat Content by Outlet for Total Sales (Pivot Table)
-- Note: MySQL doesn't support PIVOT, so we'll create a summary table instead
CREATE TABLE fat_content_by_outlet_summary AS
SELECT 
    outlet_location_type AS Outlet_Location_Type,
    item_fat_content AS Item_Fat_Content,
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_sales
GROUP BY outlet_location_type, item_fat_content
ORDER BY outlet_location_type, item_fat_content;

-- B.4 Total Sales by Outlet Establishment Year
CREATE TABLE sales_by_establishment_year AS
SELECT 
    outlet_establishment_year AS Outlet_Establishment_Year, 
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_sales
GROUP BY outlet_establishment_year
ORDER BY outlet_establishment_year;

-- B.5 Percentage of Sales by Outlet Size
CREATE TABLE sales_by_outlet_size AS
SELECT 
    outlet_size AS Outlet_Size, 
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(sales) * 100.0 / (SELECT SUM(sales) FROM blinkit_sales)) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_sales
GROUP BY outlet_size
ORDER BY Total_Sales DESC;

-- B.6 Sales by Outlet Location
CREATE TABLE sales_by_outlet_location AS
SELECT 
    outlet_location_type AS Outlet_Location_Type, 
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales
FROM blinkit_sales
GROUP BY outlet_location_type
ORDER BY Total_Sales DESC;

-- B.7 All Metrics by Outlet Type
CREATE TABLE all_metrics_by_outlet_type AS
SELECT 
    outlet_type AS Outlet_Type, 
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(sales) AS DECIMAL(10,0)) AS Avg_Sales,
    COUNT(*) AS No_Of_Items,
    CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating,
    CAST(AVG(item_visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_sales
GROUP BY outlet_type
ORDER BY Total_Sales DESC;

-- ================================================
-- ADDITIONAL INSIGHTS
-- ================================================

-- Top 10 Best Selling Items
CREATE TABLE top_10_best_sellers AS
SELECT 
    item_identifier AS Item_Identifier,
    item_type AS Item_Type,
    item_fat_content AS Item_Fat_Content,
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales,
    COUNT(*) AS Sales_Count,
    CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_sales
GROUP BY item_identifier, item_type, item_fat_content
ORDER BY Total_Sales DESC
LIMIT 10;

-- Top 10 Best Performing Outlets
CREATE TABLE top_10_outlets AS
SELECT 
    outlet_identifier AS Outlet_Identifier,
    outlet_type AS Outlet_Type,
    outlet_location_type AS Outlet_Location_Type,
    outlet_size AS Outlet_Size,
    CAST(SUM(sales) AS DECIMAL(10,2)) AS Total_Sales,
    COUNT(*) AS Item_Count,
    CAST(AVG(rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_sales
GROUP BY outlet_identifier, outlet_type, outlet_location_type, outlet_size
ORDER BY Total_Sales DESC
LIMIT 10;

-- Rating Distribution
CREATE TABLE rating_distribution AS
SELECT 
    rating AS Rating,
    COUNT(*) AS Item_Count,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM blinkit_sales) AS DECIMAL(10,2)) AS Percentage
FROM blinkit_sales
GROUP BY rating
ORDER BY rating DESC;

-- ================================================
-- EXECUTIVE SUMMARY
-- ================================================

CREATE TABLE executive_summary AS
SELECT 
    'Total Sales (Millions)' AS Metric,
    CONCAT('$', Total_Sales_Million, 'M') AS Value
FROM total_sales_million
UNION ALL
SELECT 
    'Average Sales',
    CONCAT('$', Avg_Sales)
FROM avg_sales
UNION ALL
SELECT 
    'Total Items',
    CONCAT(No_of_Orders, ' items')
FROM no_of_items
UNION ALL
SELECT 
    'Average Rating',
    CONCAT(Avg_Rating, '/5')
FROM avg_rating;

-- ================================================
-- ANALYSIS COMPLETE
-- ================================================