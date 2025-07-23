
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
----------------------- 9 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------
----------------------- 1 ---------------------