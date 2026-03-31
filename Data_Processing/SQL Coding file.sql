SELECT 
--Dates
        transaction_date AS purchase_date,
        Dayname(transaction_date) AS day_name,
        Monthname(transaction_date) AS month_name,
        Dayofmonth(transaction_date) AS day_of_month,

CASE
        WHEN Day_name IN ('Sun','Sat') THEN 'Weekend'
        ELSE 'Weekdays'
END AS day_Classification,
-- Time Bucket
        --date_format(transaction_time, 'HH:mm:ss') AS purchase_time,
        
        CASE
                WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
                WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '01. Afternoon'
                ELSE 'Evening'
END AS time_buckets,
-- Count of IDs
        COUNT(DISTINCT transaction_id) AS Number_of_sales,
        COUNT(DISTINCT product_id) AS number_of_products,
        COUNT(DISTINCT store_id) AS number_of_stores,

-- Revenue
        SUM(transaction_qty*unit_price) AS revenue_per_day,

CASE 
        WHEN revenue_per_day <=50 THEN '01. Low spend'
        WHEN revenue_per_day BETWEEN 51 AND 100 THEN '02. Med Spend'
        ELSE '03. High spend'
END AS spend_bucket,

--Categorical columns
        store_location,
        product_category,
        product_detail
FROM `bright_coffee_shop`.`project`.`Shop_analysis`
GROUP BY transaction_date,
        Dayname(transaction_date),
        Monthname(transaction_date),
        Dayofmonth(transaction_date),
CASE
        WHEN Day_name IN ('Sun','Sat') THEN 'Weekend'
        ELSE 'Weekdays'
END,
        
        CASE
                WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '00:00:00' AND '11:59:59' THEN '01. Morning'
                WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '16:59:59' THEN '01. Afternoon'
                ELSE 'Evening'
END,
        Store_location,
        product_category,
        product_detail;
