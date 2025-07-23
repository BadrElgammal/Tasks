
------------------------------ 1 -------------------------------------

Declare @total_Spent decimal(10,2)

select @total_Spent=sum( si.quantity*si.list_price*(1-si.discount))
from sales.customers SC inner join sales.orders SO
on SC.customer_id=So.customer_id
inner join sales.order_items SI
on SO.order_id=SI.order_id
where sc.customer_id = 2

print 'customar id : 1'
print 'total spent is :'+cast(@total_Spent as varchar(200))
if @total_Spent>5000
      print 'VIP Customer'
else
      print 'Regular Customer'
    

------------------------------ 2 -------------------------------------
Declare @ThresholdPrice Decimal(10,2) = 1500
Declare @priceCount int

select @priceCount =count(*)
from production.products
where list_price>@ThresholdPrice

print 'threshold price : ' + cast(@ThresholdPrice as varchar(250))
print 'number of product that above threshold : ' + cast(@priceCount as varchar(250))

------------------------------ 3 -------------------------------------
Declare @staffID int =2
Declare @year int = 2017
Declare @calulated_Total Decimal(10,2)

select count(*)
from sales.staffs SS join sales.orders SO
on SS.staff_id=So.staff_id
where SS.staff_id=2 and year(so.order_date)= @year

print 'staff id : '+cast(@staffID as varchar(250))
print 'orders year : '+cast(@year as varchar(250))
print 'count of total orders : '+cast(@calulated_Total as varchar(250))

------------------------------ 4 -------------------------------------
print @@serverName
print @@version
print @@Rowcount

------------------------------ 5 -------------------------------------
Declare @quantity int

select @quantity=si.quantity
from sales.stores SS join sales.orders SO
on SS.store_id=SO.store_id
join sales.order_items SI
on SO.order_id=SI.order_id
where SS.store_id=1 and Si.order_id=1

IF @Quantity > 20
    print 'Well stocked';
else IF @Quantity between 10 and 20
    print 'Moderate stock';
else
    print 'Low stock - reorder needed';

------------------------------ 6 -------------------------------------

Declare @BatchSize int=3
Declare @lowQuantity table(OrderID int,ItemID int)


insert into @lowQuantity(OrderID,ItemID)
select order_id , item_id
from sales.order_items
where quantity<5


while exists(select 1 from @lowQuantity)
Begin

    with Toplow as(
    select top (@BatchSize) *
    from @lowQuantity)

    update SO
    set SO.quantity =SO.quantity+10
    from sales.order_items SO join @lowQuantity SQ
    on SO.order_id=SQ.OrderID and SO.item_id=SQ.ItemID

    Delete top (@BatchSize) from @lowQuantity

    print 'Updated batch of 3 low-stock products.'
End

------------------------------ 7 -------------------------------------
select case
           when list_price< 300 then 'Budget'
           when list_price between 299 and 801 then 'Mid-Range'
           when list_price between 800 and 2001 then 'Premium'
           when list_price > 2000 then ' Luxury'
        End
from production.products

------------------------------ 8 -------------------------------------
if exists (select 1 from sales.customers where customer_id=5)
        select count(*)
        from  sales.orders 
        where customer_id =5
else
        print 'customar id not exist'

------------------------------ 9 -------------------------------------
create function dbo.Calculate_shipping (@Order_Total decimal(10,2))
returns decimal(10,2)
as 
begin
    Declare @Shipping Decimal(10,2)
    if @Order_Total > 100
        set @Shipping=0
    else if @Order_Total between 49 and 100 
        set @Shipping=5.99
    else
        set @Shipping= 12.99;
    return @Shipping
END

select dbo.Calculate_shipping(99)

------------------------------ 10 ------------------------------------

create function dbo.GetProductsByPriceRange(@minPrice decimal(10,2) , @MaxPrice decimal(10,2))
returns table
as
return(
    select pp.product_name,pp.product_id,pp.list_price,pc.category_name,pb.brand_name
    from production.categories PC join production.products PP
    on pc.category_id = pp.category_id 
    join production.brands PB
    on PB.brand_id=PP.brand_id
    where list_price between @minPrice and @MaxPrice
)

select * from dbo.GetProductsByPriceRange(500,5000)

------------------------------ 11 ------------------------------------
--Create a multi-statement function named GetCustomerYearlySummary that takes a customer ID and returns a table with yearly sales data including total orders, total spent, and average order value for each year.
create function GetCustomerYearlySummary(@customerID int)
returns @return_table table (total_orders int,total_spend decimal(10,2),AvgOrderValue decimal(10,2))
as 
    Begin
        insert into @return_table
        select count(so.order_id) as total_oreders , sum(si.list_price) as total_spend , sum(si.list_price)/count(so.order_id) 
        from sales.orders SO join sales.order_items SI
        on SO.order_id=SI.order_id
        where SO.customer_id=@customerID
        
        return;
    End

select * from dbo.GetCustomerYearlySummary(3)

------------------------------ 12 ------------------------------------
create function CalculateBulkDiscount (@quantity int)
returns decimal(10,2)
as 
    Begin
        Declare @discount decimal (10,2)
        if @quantity between 0 and 3 
            set @discount =0
        else if @quantity between 2 and 6 
            set @discount = 5 
        else if @discount between 5 and 10 
            set @discount = 10
        else if @discount > 10
            set @discount =15
        return @discount
    End

select dbo.CalculateBulkDiscount(5)

------------------------------ 13 ------------------------------------
--Create a stored procedure named sp_GetCustomerOrderHistory that accepts a customer ID and optional start/end dates. Return the customer's order history with order totals calculated.
create procedure sp_GetCustomerOrderHistory @customerID int , @StartDate Date =Null,@EndDate Date = Null
with encryption 
as 
    select @customerID,so.order_date,so.required_date,so.shipped_date ,sum(si.quantity*si.list_price*(1-si.discount)) as order_total
    from sales.customers SC join sales.orders SO
    on SC.customer_id=SO.customer_id
    join sales.order_items SI
    on so.order_id = si.order_id
    where sc.customer_id=@customerID and (@StartDate is null or so.order_date > @StartDate) and (@EndDate is null or so.order_date <@EndDate)
    Group by so.order_date,so.required_date,so.shipped_date

sp_GetCustomerOrderHistory 3

------------------------------ 14 ------------------------------------
--Write a stored procedure named sp_RestockProduct with input parameters for store ID, product ID, and restock quantity. Include output parameters for old quantity, new quantity, and success status.
create procedure sp_RestockProduct @storeID int ,@productID int ,@restockQuantity int ,@OldQuantity int out ,@newQuantity int out , @SuccessStatus int out
with encryption
as 
Begin
    Declare @curQuantity int
    select @curQuantity =  quantity
    from production.stocks 
    where store_id=@storeID and product_id=@productID

    update production.stocks
    set quantity=quantity + @restockQuantity
    where store_id=@storeID and product_id=@productID

    if @curQuantity =null
    Begin   
        set @OldQuantity = 0;
        set @newQuantity=0
        set @SuccessStatus =0 
    End
    else
    Begin
        set @OldQuantity = @curQuantity
        set @newQuantity = @curQuantity + @restockQuantity
        set @SuccessStatus =1
    End
End

Declare @oldQuantity int ,@NewQuantity int  , @successStatus int 
Exec sp_RestockProduct 3,5,5,@oldQuantity out ,@NewQuantity out , @successStatus out

print 'Old Quantity = '+ cast(@oldQuantity as varchar(250))
print 'New Quantity = '+ cast(@NewQuantity as varchar(250))
print 'Suecess state = '+ cast(@successStatus as varchar(250))


