
-------------------------- 1 ----------------------
select count(*)
from production.products

-------------------------- 2 ----------------------
select AVG(list_price) as Avarage_Price,Min(list_price) as Min_Price , Max(list_price) as Max_Price
from production.products

-------------------------- 3 ----------------------
select category_name,count(product_id)
from production.categories C inner join production.products P
on C.category_id=P.category_id
Group by category_name

-------------------------- 4 ----------------------
select SS.store_name,count(SO.order_id)
from sales.stores SS left outer join sales.orders SO
on SS.store_id = SO.store_id
Group by SS.store_name

-------------------------- 5 ----------------------
select top 10 UPPER(first_name) as First_Name,LOWER(last_name) as Last_Name
from sales.customers
order by customer_id

-------------------------- 6 ----------------------
select top 10 product_name , len(product_name)
from production.products
order by product_id

-------------------------- 7 ----------------------
select top 15 '(' +left(phone,3) +')'
from sales.customers
order by customer_id

-------------------------- 8 ----------------------

-------------------------- 9 ----------------------
select top 10 PP.product_name,pc.category_name
from production.products PP inner join production.categories PC
on PP.category_id=PC.category_id
order by pp.product_id

-------------------------- 10 ---------------------
select top 10 SC.first_name + ' ' + SC.last_name as neme ,SO.order_date
from sales.customers SC inner join sales.orders SO
on SC.customer_id=SO.customer_id
order by SO.order_id

-------------------------- 11 ---------------------
select PP.product_name,isnull(PB.brand_name,'No Brand')
from production.products PP left outer join production.brands PB
on PP.brand_id=PB.brand_id

-------------------------- 12 ---------------------
select product_name,list_price
from production.products
where list_price > (select Avg(list_price) from production.products)

-------------------------- 13 ---------------------
select customer_id,first_name + ' ' + last_name as customar_name
from sales.customers
where customer_id in (select customer_id from sales.orders )

-------------------------- 14 ---------------------
select first_name + ' ' + last_name as customar_name , (select count(*) from sales.orders SO where SC.customer_id=SO.customer_id)
from sales.customers  SC

-------------------------- 15 ---------------------
create view easy_product_list as
select PP.product_name,Pc.category_name,PP.list_price
from production.products PP, production.categories PC
where PP.category_id=PC.category_id

select *
from easy_product_list
where list_price > 100

-------------------------- 16 ---------------------
Create view customer_info as
select customer_id ,first_name + ' ' +last_name as Fullname ,email,city,state
from sales.customers

select *
from customer_info
where state='CA'

-------------------------- 17 ---------------------
select product_name,list_price
from production.products
where list_price between 50 and 200
order by list_price asc

-------------------------- 18 ---------------------
select state,count(*)
from sales.customers
Group by state

-------------------------- 19 ---------------------
select PC.category_name,PP.product_name,Max(PP.list_price)
from production.products PP,production.categories PC
where PP.category_id = PC.category_id
Group by PC.category_name,PP.product_name

-------------------------- 20 ---------------------
select store_name,city,count(SO.order_id)
from sales.stores SS , sales.orders SO
where SS.store_id=SO.store_id
Group by  store_name,city
