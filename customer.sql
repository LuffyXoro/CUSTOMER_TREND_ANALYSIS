select * from customer_shopping_behavior limit 10;

--Total revenue by gender 

select gender,sum(purchase_amount) as revenue 
from customer_shopping_behavior
group by gender;

-- has discount but still more than average purchase amount 

select customer_id ,purchase_amount
from customer_shopping_behavior
where discount_applied='Yes' and purchase_amount>=(select avg(purchase_amount) from customer_shopping_behavior);

--top 5 products with highest average review rating
SELECT item_purchased,
       ROUND(AVG(review_rating)::numeric, 2) AS avg_rating
FROM customer_shopping_behavior
GROUP BY item_purchased
ORDER BY avg_rating DESC
LIMIT 5;

-- avergae purchase amounts b/t shippings 

select shipping_type,
avg(purchase_amount)
from customer_shopping_behavior 
where shipping_type in ('Standard','Express')
group by shipping_type;

--average spend and total revenue b/t subscribed and non-subscribed

select subscription_status,
count(customer_id) as Total_Customer,
ROUND(Avg(purchase_amount),2) as Avg_Amount,
Round(sum(purchase_amount),2) as Total_Amount
from customer_shopping_behavior
group by subscription_status;

-- 10 products have the highest percentage of purchases with discounts applied?
select item_purchased,
round(100*sum(case when discount_applied='Yes' then 1 else 0 end)/count(*),2) as rate_of_discount
from customer_shopping_behavior
group by item_purchased
order by rate_of_discount desc limit 10 ;

-- 3 most purchased products within each category?
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer_shopping_behavior
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;


-- segmeting customers into new , returning and loyal based on purchases 

with customer_type as (
SELECT customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM customer_shopping_behavior)

select customer_segment,count(*) AS "Number of Customers" 
from customer_type 
group by customer_segment;

-- revenue by age groups

select age_group,
sum(purchase_amount) as TotalRevenue
from customer_shopping_behavior
group by age_group
order by TotalRevenue DESC;

-- Are the freq. repeated buyers , subscribes too?

select subscription_status,
count(customer_id) as Repeated_Buyers
from customer_shopping_behavior
where previous_purchases>10
group by subscription_status;

-- Top 5 purchased products within each category 

with item_counts as (
select category,
item_purchased,
count(customer_id)as Total_Orders,
ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
from customer_shopping_behavior
group by category,item_purchased
)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank<=3;









