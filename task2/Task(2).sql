

---------------------1-----------------
select *
from production.products
where list_price > 1000

---------------------2-------------------
select *
from sales.customers
where state in ('CA','NY')

---------------------3--------------------
select *
from sales.orders
where order_date between '12-31-2022' and '01-01-2024'

---------------------4---------------------
select *
from sales.customers
where email like '%@gmail.com'

---------------------5---------------------
select *
from sales.staffs
where active = 0

---------------------6---------------------
select top 5 list_price
from production.products
order by list_price desc

---------------------7---------------------
select top 10 *
from sales.orders
order by order_date desc

---------------------8---------------------
select top 3 *
from sales.staffs
order by last_name asc

---------------------9---------------------
select *
from sales.customers
where phone is null

---------------------10---------------------
select *
from sales.staffs
where manager_id is null

---------------------11---------------------
select PC.category_name,count(PP.product_id) as Product_Count
from production.categories PC left outer join production.products PP
on PC.category_id=PP.category_id
Group by category_name 

---------------------12---------------------
select state,count(customer_id) as Custumer_Count
from sales.customers
Group by state

---------------------13---------------------
select brand_id ,AVG(list_price)
from production.products 
Group by brand_id

---------------------14---------------------
select SS.staff_id , count(SO.order_id)
from sales.staffs SS left outer join sales.orders SO
on SS.staff_id=SO.staff_id
Group by SS.staff_id

---------------------15---------------------
select SC.customer_id,count(SO.order_id)
from sales.customers SC left outer join sales.orders SO
on SC.customer_id = SO.customer_id
Group by SC.customer_id
Having count(SO.order_id)>2

---------------------16---------------------
select list_price
from production.products
where list_price between 500 and 1500

---------------------17---------------------
select *
from sales.customers
where city like 'S%'

---------------------18--------------------
select *
from sales.orders
where order_status in(2,4)

---------------------19--------------------
select *
from production.products
where category_id in(1,2,3)

---------------------20--------------------
select *
from sales.staffs
where store_id=1 or phone is null
