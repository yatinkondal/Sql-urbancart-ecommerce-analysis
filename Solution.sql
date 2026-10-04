create database Urban_cart_retail_store;
use urban_cart_retail_store;
set sql_safe_updates=0;
-- Q1. Find the total number of orders placed.
select count(order_id) as No_of_orders from orders;

-- Q2. Find the total quantity of items sold across all orders.
select sum(quantity) as Total_Qty from orders;

-- Q3. Find the average unit price of all products, rounded to 2 decimal places.
select round(avg(unit_price),2) as AvgPrice from orders;

-- Q4. Show the cheapest and the costliest unit price in the orders table.
select max(unit_price) as CostliestPrice,min(Unit_price) as CheapestPrice from orders;

-- Q5. For every order, show the order id, quantity, unit price and the gross amount
select Order_id,Quantity,Unit_price,round((unit_price)*quantity,2) as Gross_Amount from orders;

-- Q6. For every order, calculate the net amount after applying the discount percentage. Round it to 2 decimals.
select Order_id,round((unit_price-unit_price*(discount_pct/100))*quantity,2) as Net_Amount from orders;

-- Q7. Show the average gross order value along with its CEILING and FLOOR values.
select avg((unit_price-unit_price*(discount_pct/100))*quantity) as Grossvalue,floor(avg((unit_price-unit_price*(discount_pct/100))*quantity))
as Floor ,ceiling(avg((unit_price-unit_price*(discount_pct/100))*quantity)) as Ceiling from orders;

-- Q8. How many different product categories are sold?
select count(distinct category) as Categories from orders;

-- Q9. Show category wise total revenue after discount, highest revenue first.
select Category,round(sum((unit_price-unit_price*(discount_pct/100))*quantity),2) as TotalRevenue from orders 
group by category order by round(sum((unit_price-unit_price*(discount_pct/100))*quantity),2) desc ;

-- Q10. For each payment mode, show the number of orders and the average quantity.
select Payment_Mode,count(order_id) as No_of_orders,round(avg(quantity),1) as Avg_Qty from 
orders group by payment_mode;

-- Q11. Display the full name of every customer in a single column.
select concat(first_name," ",Last_name) as Full_name from customers;

-- Q12. Display each customer's email in capital letters and city in small letters.
select upper(email) as EMAIL, lower(city) as city from customers;

-- Q13. Show the full name of each customer along with the number of characters in that name.
select concat(first_name," ", last_name) as FullName, length(concat(first_name," ", last_name))-1 as Length from customers;

-- Q14. Create a 3 letter city code in capital letters from the city column (example: Bengaluru becomes BEN).
select upper(substring(city,1,3)) as Code from customers;

-- Q15. Extract only the email domain (the part after the @ symbol) for every customer.
select substring_index(email,"@",-1) as Domain  from customers;

-- Q16. Display the initials of every customer in the format A.S. for Aarav Sharma.
select concat(substring(first_name,1,1),".",substring(last_name,1,1),".") as Code from customers;

-- Q17. Mask the phone number so that only the last 4 digits are visible, like XXXXXX1234.
select concat(repeat("X",length(phone)-4), right(phone,4)) as MaskedNo from customers;

-- Q18. List all customers whose first name has more than 5 characters.
select First_name from customers where length(first_name)>5;

-- Q19. Display the current date and time of the database server.
select now() as Date_and_Time;

-- Q20. For every delivered order, show how many days the delivery took
select Order_id ,datediff(delivery_date,Order_date) as Days from orders where delivery_date!="";

-- Q21. List the orders that took more than 7 days to reach the customer.
select Order_id from orders where datediff(delivery_date,order_date)>7;

-- Q22. The company promises delivery within 7 days. Show the promised delivery date for every order.
select Order_id , date_add(order_date,interval 7 day) as Promised_Date from orders;

-- Q23. List all orders placed in the last 45 days of the year 2024
select Order_id from orders where order_date>=date_sub("2024-12-31",interval 44 day);

-- Q24. For every customer, show how many days they have been with the company and how many completed
-- years that is.
select customer_id,round(datediff(curdate(),signup_date)/365,2) as Years,(datediff(curdate(),signup_date)) as Days from customers;

-- Q25. Show the number of orders placed in each month.
select month(order_date) as MonthNo,monthname(order_date) as MonthName,count(order_id) as NumberofOrders from orders group by month(order_date), monthname(order_date) order by month(order_date) asc;

-- Q26. List all orders that are still not delivered and show how many days have passed since they were placed.
select Order_id ,datediff(curdate(),order_date) as DaysPassed from orders where delivery_date="";

-- Q27. Label each customer's income as 'High', 'Medium' or 'Low' — High for 1,000,000 and above, Medium for
-- 700,000 up to but not including 1,000,000, and Low for anything below 700,000.
select Customer_id,
case 
when annual_income>=1000000 then "High"
when annual_income>=700000 then "Medium"
else "Low" 
end as Category
from customers;

-- Q28. For every order, show whether the discount given was 'No Discount', 'Low' (up to 10 percent), or 'High'
-- (above 10 percent).
select Order_id, 
case 
when discount_pct="" then "No Discount"
when discount_pct<=10 then "Low"
else "High"
end as Category
from orders;

-- Q29. For every order, classify the order size as 'Small' (gross amount below 2000), 'Medium' (2000 up to 8000)
-- or 'Large' (8000 and above).
select Order_id,
case 
when unit_price*quantity>=8000 then "Large"
when unit_price*quantity>=2000 then "Medium"
else "Small" 
end as Category 
from orders;

-- Q30. Show each customer's tenure with the company in years, and next to it a tag: 'New' for less than 2 years,
-- 'Established' for 2 up to 4 years, and 'Loyal' for 4 years and above.
select Customer_id,timestampdiff(year,signup_date,curdate()) as Years,
case 
when timestampdiff(year,signup_date,curdate())>=4 then "Loyal"
when  timestampdiff(year,signup_date,curdate())>=2 then "Established"
else "New" end as Category
from customers;

-- Q31. For every order, show a simple payment type: 'Cash' for cash on delivery, and 'Digital' for every other payment mode.
select Order_id ,
case 
when payment_mode="cod" then "Cash"
else "Digital" end
as Category from orders;
 
-- Q32. For every order, show a delivery status: 'Delivered' if a delivery date exists, and 'Pending' if it does not.
select Order_id ,
case 
when delivery_date!="" then "Delivered"
else "Pending" end
as Category from orders;

-- Q33. For delivered orders, tag the delivery speed as 'Fast' (3 days or less), 'Normal' (4 to 7 days) or 'Slow'
-- (more than 7 days).
select Order_id ,
case 
when datediff(delivery_date,order_date)>7 then "Slow"
when datediff(delivery_date,order_date)>=4 then "Normal"
else "Fast" end 
as Category from orders
where delivery_date !="";

-- Q34. Count how many customers fall into each income band described earlier (High, Medium, Low) in a single
-- result.
with cte as(
select Customer_id,
case 
when annual_income>=1000000 then "High"
when annual_income>=700000 then "Medium"
else "Low" 
end as Category
from customers
)
select Category, count(customer_id) as Number_of_customers from cte group by Category order by Category asc;

-- Q35. Show the order id, customer full name and product name for every order that has a matching customer
-- record.
select o.Order_id,concat(c.first_name," ",c.last_name) as FullName, o.Product_name from orders as o inner join customers as c 
on c.customer_id= o.customer_id;

-- Q36. List all orders placed by Gold tier customers only.
select o.Order_id from customers as c inner join orders as o on c.customer_id=o.customer_id
where c.loyalty_tier="Gold";

-- Q37. Show every customer along with the number of orders they have placed. Customers with zero orders
-- must also appear.
select c.Customer_id, count(order_id) as No_of_orders from customers as c left join orders as o 
on c.customer_id= o.customer_id group by Customer_id;

-- Q38. List the customers who have never placed a single order.
select c.Customer_id, count(order_id) as No_of_orders from customers as c left join orders as o 
on c.customer_id= o.customer_id group by Customer_id having count(order_id)=0;

-- Q39. Show all orders along with the customer name. Orders must appear even if the customer record is
-- missing.
select o.Order_id, concat(c.first_name," ", c.last_name) as FullName from customers as c right join orders as o 
on c.customer_id= o.customer_id ;

-- Q40. Find the orders whose customer record is missing from the customers table
select o.Order_id from orders as o left join customers as c 
on c.customer_id=o.customer_id where c.Customer_id is NULL;

-- Q41. Combine every customer and every order into a single result, so that customers who never ordered and
-- orders with no matching customer both still appear.
select c.Customer_id , o.Order_id from customers as c left join orders as o
on c.customer_id=o.customer_id
union
select c.customer_id , o.order_id from customers as c right join orders as o
on c.customer_id=o.customer_id;

-- Q42. Show only the unmatched rows from both sides, that is, customers with no orders and orders with no
-- customer.
select c.Customer_id , o.Order_id from customers as c left join orders as o
on c.customer_id=o.customer_id where o.order_id is null
union
select c.customer_id , o.order_id from customers as c right join orders as o
on c.customer_id=o.customer_id where c.customer_id is null;

-- Q43. Find the total amount spent by each customer after discount. Show only customers who have placed at
-- least one order.
select c.Customer_id,round(sum((o.unit_price-o.unit_price*(o.discount_pct/100))*o.quantity),1) as TotalAmount from
customers as c inner join orders as o on c.customer_id=o.customer_id group by c.Customer_id
having count(order_id)>=1 order by c.Customer_id;

-- Q44. Find city wise revenue based on the customer's home city.
select c.City, round(sum((o.unit_price-o.unit_price*(o.discount_pct/100))*o.quantity),1) as TotalAmount from 
customers as c inner join orders as o on c.customer_id=o.customer_id group by c.city;

-- Q45. List the orders that were shipped to a city different from the customer's home city.
select o.Order_id, c.city,o.Ship_city from orders as o inner join customers as c on c.customer_id=
o.customer_id where  c.city!=o.Ship_city;

-- Q46. Show the customer name, product name and the number of days the delivery took, for delivered orders
-- only.
select c.First_name, o.Product_name ,datediff(o.delivery_date,o.order_date) as DaysTook from customers as c inner join 
orders as o on c.customer_id=o.customer_id where delivery_date!=""; 

-- Q47. Find the average order value for each loyalty tier, rounded to 2 decimals.
select c.loyalty_tier,round(avg((o.unit_price-o.unit_price*(o.discount_pct/100))*o.quantity),2) as AvgRevenue
from customers as c inner join orders as o on c.customer_id=o.customer_id group by c.loyalty_tier;

-- Q48. List the customers who have placed more than 3 orders.
select c.Customer_id from customers as c inner join 
orders as o on c.customer_id=o.customer_id group by c.customer_id having count(o.order_id)>3 ;

-- Q49. Number all orders from the highest net amount to the lowest.
select Order_id,round((unit_price-unit_price*(discount_pct/100))*quantity,1) as NETAMOUNT from orders order by 
round((unit_price-unit_price*(discount_pct/100))*quantity,1) desc;

-- Q50. Rank the customers by their total spend, highest spender getting rank 1.
select c.Customer_id, round(sum((o.unit_price-o.unit_price*(o.discount_pct/100))*o.quantity),1) as Spend ,
dense_rank() over (order by (round(sum((o.unit_price-unit_price*(o.discount_pct/100))*o.quantity),1))desc)
as Ranking  from customers as c inner join orders as o 
on c.customer_id=o.customer_id group by c.Customer_id ;

-- Q51. For every category, rank the orders by quantity, from the highest quantity to the lowest. Show this two
-- ways side by side: one where tied orders get the same rank but the rank number skips ahead afterward, and
-- one where tied orders get the same rank with no numbers skipped.
select Category,order_id ,Quantity as QTY, dense_rank() over (partition by Category order by Quantity desc) as DenseRank,
rank() over (partition by category order by Quantity desc) as NormalRank
from orders;
  
-- Q52. Divide the customers into 4 equal groups based on their total spend, where group 1 is the highest
-- spending group.
select Customer_id,sum((unit_price-unit_price*(discount_pct/100))*quantity) as Sum ,ntile(4) over 
(order by sum((unit_price-unit_price*(discount_pct/100))*quantity)desc ) as Grp from orders group by Customer_id;

-- Q53. For each customer, show the previous order date and the gap in days between two consecutive orders.
with cte as 
(
select Customer_id,Order_date,lag(order_date) over ( partition by Customer_id order by Order_date) as Prev_date from orders
)
select Customer_id, Order_date,Prev_date,datediff(order_date,prev_date) as Difference from cte;

-- Q54. For each customer, show the next order date after the current one.
select Customer_id,Order_date,lead(order_date) over ( partition by Customer_id order by Order_date) as Next_date from orders;

-- Q55. Show the top 2 orders by net amount in each category.
with cte as
(
select Category,order_id,(unit_price-unit_price*(discount_pct/100))*quantity as Sum ,
dense_rank() over ( partition by category order by (unit_price-unit_price*(discount_pct/100))*quantity desc) as Ranking
from orders 
)
Select Category,Order_id,Sum  from cte
where Ranking<=2;

-- Q56. For each customer, show a running total of their spend in order of date.
select Customer_id,Order_date,sum((unit_price-unit_price*(discount_pct/100))*quantity)
 over (partition by customer_id order by order_date)  as RunningTotal from orders order by Customer_id,order_date;

-- Q57. Within each state, order the customers from the highest annual income to the lowest and number them
-- starting from 1 in every state.
select State,Customer_id,Annual_income,dense_rank() over (partition by state order by Annual_income desc) as Ranking from customers;

-- Q58. For each payment mode, number the orders from the earliest order date to the most recent.
select Payment_mode,Order_date,row_number() over (partition by payment_mode order by Order_date,order_id) as OrderNo from orders;

-- Q59. Show month wise revenue along with the previous month revenue and the change between them.
with cte as (
select month(order_date) as MonthNo,monthname(order_date) as MonthName,sum((unit_price-unit_price*(discount_pct/100))*quantity) as Sum 
,lag(sum((unit_price-unit_price*(discount_pct/100))*quantity)) over(order by month(order_date)) as PrevSum
from orders group by month(order_date),monthname(order_date) order by month(order_date)
)
select MonthName,Sum,PrevSum,Sum-PrevSum as Diff from cte;

-- Q60. Find the second highest order value in each ship city.
with cte as
(
select Ship_City,(unit_price-unit_price*(discount_pct/100))*quantity as Ordervalue,dense_rank() over
(partition by Ship_city order by (unit_price-unit_price*(discount_pct/100))*quantity desc) as OrderValueRank
from orders
)
select Ship_city,OrderValue from cte where OrderValueRank=2;

-- Q61. For every customer who has ordered, show their first order date, last order date and the number of days
-- between the two.
select c.Customer_id , min(o.order_date) FirstDate,max(o.order_date) as LastDate , datediff(max(o.order_date),min(o.order_date))
as DaysBetween from customers as c inner join orders as o on c.customer_id=o.customer_id group by c.Customer_id;

-- Q62. Show each category's revenue and what percentage it contributes to the total revenue.
with cte as(
select o.Category as Cat,sum((o.unit_price-o.unit_price*(o.discount_pct/100))*o.quantity) as Revenue
from customers as c inner join orders as o on c.customer_id=o.customer_id
group by o.Category
)
select Cat,round(Revenue,1) as Revenue,round(Revenue*100/(select sum(Revenue) from cte),1) as Percentage from cte;

-- Q63. Show month wise revenue along with the cumulative revenue for the year.
with cte as (
select month(order_date) as MonthNo,monthname(order_date) as MonthName,sum((unit_price-unit_price*(discount_pct/100))*quantity) as Sum 
from orders group by month(order_date),monthname(order_date) order by month(order_date)
)
select MonthName, Sum ,Sum(sum) over (order by MonthNo) as CumRev from cte;

-- Q64. List every customer, whether they ordered or not, along with their total spend, showing 0 for customers
-- with no orders.
select c.Customer_id,coalesce(sum((o.unit_price-o.unit_price*(o.discount_pct/100))*o.quantity),0) as TotalSpend
from customers as c left join orders as o on c.customer_id=o.customer_id group by c.Customer_id;

-- Q65. For every order, compare its net amount to the average net amount of its own category, and label it
-- 'Above Average' or 'Below Average' accordingly.
select Order_id,Category,(unit_price-unit_price*(discount_pct/100))*quantity as Amount,
(avg((unit_price-unit_price*(discount_pct/100))*quantity) over (partition by category)) as Category_Average,
case
when (unit_price-unit_price*(discount_pct/100))*quantity>(avg((unit_price-unit_price*(discount_pct/100))*quantity) over (partition by category)) then "Above Average"
when (unit_price-unit_price*(discount_pct/100))*quantity<(avg((unit_price-unit_price*(discount_pct/100))*quantity) over (partition by category))  then "Below Average"
else "Average"
end as Type
from orders;









