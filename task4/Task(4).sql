
----------------------- 1 ---------------------
select list_price,case
         when list_price < 300 then 'Economy'
         when list_price between 299 and 1000  then 'Standard'
         when list_price between 999 and 2500 then 'Premium'
         when list_price >= 300 then 'Luxury'
       End
from production.products

----------------------- 2 ---------------------
select order_id , 
        case
           when order_status = 1 then 'Order Received'
           when order_status = 2 then 'In Preparation'
           when order_status = 3 then 'Order Cancelled'
           when order_status = 4 then 'Order Delivered'
        End as order_Status ,
        case
           when order_status = 1 and DateDiff(day,order_date,required_date) > 5 then 'URGENT'
           when order_status = 2 and DateDiff(day,order_date,required_date) > 3 then 'HIGH'
           Else 'NORMAL'
        End as priority_level
from sales.orders

----------------------- 3 ---------------------
select SS.staff_id,SS.first_name ,count(SO.order_id),
          case 
              when count(SO.order_id) = 0 then 'New Staff'
              when count(SO.order_id) between 0 and 11 then 'Junior Staff'
              when count(SO.order_id) between 10 and 26 then 'Senior Staff'
              when count(SO.order_id) >= 26 then 'Expert  Staff'
          End
from sales.staffs SS left outer join sales.orders SO
on SS.staff_id=SO.staff_id 
Group by SS.staff_id , SS.first_name

----------------------- 4 ---------------------
select customer_id, first_name + ' ' + last_name AS customer_name, phone, email,
    isnull(phone, 'Phone Not Available'),
    COALESCE(phone, email, 'No Contact Method') 
from sales.customers

----------------------- 5 ---------------------
select PP.product_name ,PP.list_price,Ps.quantity ,
       isnull(PP.list_price / Nullif(PS.quantity,0),0),
       case
          when PS.quantity = 0 then 'No Stock'
          Else 'In stock'
       End
from production.products PP ,production.stocks PS
where PP.product_id=PS.product_id and PS.store_id=1

----------------------- 6 ---------------------
Select customer_id,first_name+' '+ last_name [Full Name],
  COALESCE(street, '') AS street_address,
  COALESCE(city, '') AS city,
  COALESCE(state, '') AS state,
  isnull(zip_code, 'Zip Not Available') AS zip_code,
  Concat (street,city,state ,zip_code)
from sales.customers

----------------------- 7 ---------------------
with customar_Spending as(
     select so.customer_id,sum(si.quantity*si.list_price*(1-si.discount)) as total_Spent
     from sales.orders SO, sales.order_items SI
     where so.order_id=si.order_id
     Group by so.customer_id
)

select SC.customer_id,SC.first_name + ' ' + sc.last_name as Full_Name, cs.total_Spent
from customar_Spending CS , sales.customers SC
where cs.customer_id=sc.customer_id and cs.total_Spent >1500

----------------------- 8 ---------------------
/*Create a multi-CTE query for category analysis:

CTE 1: Calculate total revenue per category
CTE 2: Calculate average order value per category
Main query: Combine both CTEs
Use CASE to rate performance: >$50000 = "Excellent", >$20000 = "Good", else = "Needs Improvement"*/
with CategoryRevenue AS (
    select p.category_id,SUM(oi.quantity * oi.list_price) as total_revenue
    from production.products p
    join sales.order_items oi 
        on p.product_id = oi.product_id
    group by p.category_id
),
CategoryAvgOrderValue as (
    select   p.category_id,
        AVG(oi.quantity * oi.list_price) as avg_order_value
    from production.products p
    join sales.order_items oi 
        on p.product_id = oi.product_id
    group by p.category_id
)

select c.category_id, c.category_name,cr.total_revenue, ca.avg_order_value,
    case 
        when cr.total_revenue > 50000 then 'Excellent'
        when cr.total_revenue > 20000 then 'Good'
        else 'Needs Improvement'
    end as performance_rating
from CategoryRevenue cr
join CategoryAvgOrderValue ca 
    on cr.category_id = ca.category_id
join production.categories c
    on c.category_id = cr.category_id
order by cr.total_revenue DESC;

----------------------- 9 ---------------------
/*Use CTEs to analyze monthly sales trends:

CTE 1: Calculate monthly sales totals
CTE 2: Add previous month comparison
Show growth percentage*/
with MonthlySales as (
    select 
        FORMAT(o.order_date, 'yyyy-MM') as sales_month,
        SUM(oi.quantity * oi.list_price ) as total_sales
    from sales.orders o
    join sales.order_items oi  
    on o.order_id = oi.order_id    
    group by FORMAT(o.order_date, 'yyyy-MM')
)

select  cur.sales_month, cur.total_sales,   prev.total_sales AS previous_month_sales,

    case 
        when prev.total_sales IS NULL then NULL
        WHEN prev.total_sales = 0 THEN NULL
        ELSE ROUND(((cur.total_sales - prev.total_sales) * 100.0) / prev.total_sales, 2)
    END AS growth_percentage
FROM MonthlySales cur
LEFT JOIN MonthlySales prev 
    ON FORMAT(DATEADD(MONTH, 1, CAST(prev.sales_month + '-01' AS DATE)), 'yyyy-MM') = cur.sales_month
ORDER BY cur.sales_month;

----------------------- 10 --------------------
/*Create a query that ranks products within each category:

Use ROW_NUMBER() to rank by price (highest first)
Use RANK() to handle ties
Use DENSE_RANK() for continuous ranking
Only show top 3 products per category*/
WITH ProductRanks AS (
    SELECT   p.category_id,  c.category_name,   p.product_id,
   p.product_name,  p.list_price,     
     
        ROW_NUMBER() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS row_num,
        RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS rank_num,
        DENSE_RANK() OVER (PARTITION BY p.category_id ORDER BY p.list_price DESC) AS dense_rank_num
    FROM production.products p
    JOIN production.categories c
        ON p.category_id = c.category_id
)

SELECT  category_id, category_name,    product_id,product_name,
list_price, row_num,  rank_num, dense_rank_num  
FROM ProductRanks
WHERE row_num <= 3
ORDER BY category_id, row_num;

----------------------- 11 --------------------
/*Rank customers by their total spending:

Calculate total spending per customer
Use RANK() for customer ranking
Use NTILE(5) to divide into 5 spending groups
Use CASE for tiers: 1="VIP", 2="Gold", 3="Silver", 4="Bronze", 5="Standard"*/
WITH  Customer_Spending AS (
    select sc.customer_id,sc.first_name,sum(OI.quantity*OI.list_price) as total_spending
    from sales.customers SC join sales.orders SO
    on SC.customer_id = SO.customer_id
    join sales.order_items OI
    on SO.order_id = OI.order_id
    group by sc.customer_id,sc.first_name
),
Ranked_Customers AS (
    select 
        customer_id,
        total_spending,
        RANK() OVER (ORDER BY total_spending DESC) AS SpendingRank,
        NTILE(5) OVER (ORDER BY total_spending DESC) AS SpendingGroup
    from 
        Customer_Spending
)
select 
    customer_id,
    total_spending,
    SpendingRank,
    SpendingGroup,
    case SpendingGroup
        WHEN 1 THEN 'VIP'
        WHEN 2 THEN 'Gold'
        WHEN 3 THEN 'Silver'
        WHEN 4 THEN 'Bronze'
        WHEN 5 THEN 'Standard'
    END AS Tier
from 
    Ranked_Customers
order by 
    SpendingRank;

----------------------- 12 --------------------
/*Create a comprehensive store performance ranking:

Rank stores by total revenue
Rank stores by number of orders
Use PERCENT_RANK() to show percentile performance*/
WITH StorePerformance AS (
    select 
        ss.store_id,
        ss.store_name,
        COUNT(DISTINCT so.order_id) AS total_orders,
        SUM(oi.quantity * oi.list_price) AS total_revenue
    from 
        sales.stores SS join sales.orders SO 
        on ss.store_id = so.store_id
        join sales.order_items oi ON so.order_id = oi.order_id
    group by ss.store_id, ss.store_name
),
RankedStores as (
    select 
        store_id,
        store_name,
        total_orders,
        total_revenue,
        RANK() OVER (ORDER BY total_revenue DESC) AS RevenueRank,
        RANK() OVER (ORDER BY total_orders DESC) AS OrderCountRank,
        PERCENT_RANK() OVER (ORDER BY total_revenue DESC) AS RevenuePercentile,
        PERCENT_RANK() OVER (ORDER BY total_orders DESC) AS OrderCountPercentile
    from 
        StorePerformance
)
SELECT 
    store_id,
    store_name,
    total_revenue,
    total_orders,
    RevenueRank,
    OrderCountRank,
    CAST(RevenuePercentile * 100 AS DECIMAL(5,2)) AS RevenuePercentile,
    CAST(OrderCountPercentile * 100 AS DECIMAL(5,2)) AS OrderCountPercentile
FROM 
    RankedStores
ORDER BY 
    RevenueRank;

