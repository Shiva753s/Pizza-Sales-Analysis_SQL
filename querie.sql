# -- total no. of orders placed

select count(order_id)
from orders;

-- Total Revenue

SELECT 
    SUM(quantity * price) total_sales
FROM
    order_details a
        JOIN
    pizzas b ON a.pizza_id = b.pizza_id;
    
    -- highest pizza price
    
    select a.pizza_type_id, a.price, b.name
    from pizzas a
    join pizza_types b
    on a.pizza_type_id = b.pizza_type_id
    order by a.price desc
    limit 1;
    
-- size of pizza commonly ordered

select count(quantity), size
from order_details a
join pizzas b
on a.pizza_id = b.pizza_id
group by size
order by 1 desc
limit 1;

-- top 5 pizza's ordered and quantity

select c.name, sum(quantity)
from order_details a 
join pizzas b on a.pizza_id = b.pizza_id
join pizza_types c on b.pizza_type_id = c.pizza_type_id
group by 1
order by 2 desc
limit 5;
    
-- by category quantity ordered
    
    select c.category, sum(quantity)
from order_details a 
join pizzas b on a.pizza_id = b.pizza_id
join pizza_types c on b.pizza_type_id = c.pizza_type_id
group by 1 
;
-- Average order per hour

SELECT 
    HOUR(order_time), COUNT(order_time)
FROM
    orders
GROUP BY 1
order by 1;

-- how many type of pizza per category

select category,count(category)
from pizza_types
group by 1;

-- Average order per day

with tin as (select date(order_date), sum(quantity) tl from orders a
join order_details b
on a.order_id = b.order_id
group by date(order_date))
select avg(tl) from tin;

-- top 3 most ordered pizza type based on revenue

select name, sum( quantity * price) as revenue
from pizzas a
join order_details b 
on a.pizza_id = b.pizza_id
join pizza_types c
on a.pizza_type_id = c.pizza_type_id
group by name
order by revenue desc
limit 3;
-- percentage wise revenue per category 

with tint as(select category, sum( quantity * price) as revenue
from pizzas a
join order_details b 
on a.pizza_id = b.pizza_id
join pizza_types c
on a.pizza_type_id = c.pizza_type_id
group by category), tant as
(select category, revenue, (select sum(revenue) as rev from tint) as rev from tint )

select category, (revenue/rev)*100 , revenue
from tant;
-- cumulative revenue per day

with cunt as
(select order_date, sum(price*quantity) as `revenue per day`
from order_details a
join pizzas b
on a.pizza_id = b.pizza_id
join orders c
on c.order_id = a.order_id
group by 1) 
select order_date, sum(`revenue per day`) over(order by order_date)
from cunt;

-- top pizza in revenue each category

with top as (select name, category, sum(price*quantity) revenue
from order_details a
join pizzas b on a.pizza_id = b.pizza_id
join pizza_types c on b.pizza_type_id = c.pizza_type_id
group by  name, category ), titu as
 (select category , name , row_number () over(partition by category order by revenue desc) tita from top)
 select category, name, tita from titu where tita <=3 ;
