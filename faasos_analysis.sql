
-- how many rolls were ordered

select count(*) from faasos_projects.customer_orders co 


--  how many unique customers orders were made

select count(distinct customer_id)  from faasos_projects.customer_orders co  


-- how many succesful orders were delivered by each driver

select driver_id, count(order_id) from faasos_projects.driver_order do2 
where coalesce(Cancellation,'') <> 'Cancellation' and  coalesce(Cancellation,'')<> 'Customer Cancellation'
--where coalesce(cancellation,'') not in ('Cancellation','Customer Cancellation')
group by driver_id


--  how many each type of roll was delivered
--select * from faasos_projects.customer_orders co  ;

select r.roll_id,roll_name,count(*) from faasos_projects.driver_order do2 
join faasos_projects.customer_orders co on co.order_id = do2.order_id 
join faasos_projects.rolls r on co.roll_id = r.roll_id 
where coalesce(do2.cancellation,'') not in ('Cancellation','Customer Cancellation')
group by 1,2
order by 1



-- how many veg and non-veg rolls were ordered by each customer
select x.*,r.roll_name from 
(select customer_id _id,roll_id,count(roll_id) from faasos_projects.customer_orders co 
group by 1,2)x
join faasos_projects.rolls r  on r.roll_id = x.roll_id
order by 1
 

-- what is the maximum number of rolls delivered in a single order

select order_id,count(roll_id) from
(select  * from faasos_projects.customer_orders co 
where order_id in (select order_id from
(select *, 
case when Cancellation in ('Cancellation','Customer Cancellation') then 'ndv' else 'dv' end delivery 
from faasos_projects.driver_order do2)t1
where delivery = 'dv')
)
group by 1
order by 2 desc
limit 1


-- For each customer, how many deliverd rolls had at least 1 change and how many had no changes

with cte1 as (select order_id ,customer_id ,roll_id ,
case when not_include_items is null or not_include_items ='' then '0' else not_include_items end not_include_items ,
case when extra_items_included is Null or extra_items_included = '' or extra_items_included = 'NaN' or extra_items_included = 'NULL' then '0' else extra_items_included end extra_items_included
from faasos_projects.customer_orders co 
),
cte2 as 
(select *,
case when coalesce(cancellation,'') not in ('Cancellation','Customer Cancellation') then '0' else '1' end dvreport
from faasos_projects.driver_order do2)
select customer_id,order_chng,count(order_chng) from 
(select *,
case when not_include_items='0' and extra_items_included = '0' then 'No changes' else 'changes' end order_chng
from cte1 
where order_id in (
select order_id from cte2 where dvreport <> '1' 
)
)
group by 1,2
order by 1



--  how many rolls were delivered that had both exclusions and extras

with cte1 as (select order_id ,customer_id ,roll_id ,
case when not_include_items is null or not_include_items ='' then '0' else not_include_items end not_include_items ,
case when extra_items_included is Null or extra_items_included = '' or extra_items_included = 'NaN' or extra_items_included = 'NULL' then '0' else extra_items_included end extra_items_included
from faasos_projects.customer_orders co 
),
cte2 as 
(select *,
case when coalesce(cancellation,'') not in ('Cancellation','Customer Cancellation') then '0' else '1' end dvreport
from faasos_projects.driver_order do2)
select count(roll_id) from
(select *,
case when not_include_items='0' and extra_items_included = '0' then 'No changes' else 'changes' end order_chng
from cte1 
where order_id in (
select order_id from cte2 where dvreport <> '1' 
))
where not_include_items <>'0'and extra_items_included<>'0'



-- what was the total number of rolls ordered for each hour of the day

select hours,count(hours) 
from
(
select distinct order_id,concat(EXTRACT(HOUR FROM order_date) ,'-' ,date_part('hour',order_date)+1) hours
from faasos_projects.customer_orders co 
)t1
group by 1
order by 1;


-- what was the number of orders for each day of the week

select dow,count(distinct order_id) from
(select *,
TO_CHAR(order_date,'Day') as dow
from faasos_projects.customer_orders co 
)t1
group by 1



-- what was the average time in  minutes it took for each driver  to arrive at the fassos hq to pickup the order
--  i use is not null  for orders that are delivered beacuse of cancellation
--we can also use avg function


select driver_id,round(sum(diff)/count(driver_id),2) avrg from
(
select *,row_number() over(partition by order_id ) rnk from
(
select co.*,do2.driver_id,do2.pickup_time,do2.duration,extract(minute from (pickup_time - order_date)) diff
from faasos_projects.customer_orders co 
join faasos_projects.driver_order do2 on co.order_id  = do2.order_id 
where do2.pickup_time is not null)a
) where rnk = 1
group by 1;


