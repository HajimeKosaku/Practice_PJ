-- customer_id数の確認 (o_orders_dataset)
select distinct count(customer_id)
--select *
from o_orders_dataset;
-- -> 99,441

-- customer_id数の確認 (o_customers_dataset)
--select *
select distinct count(customer_id)
from o_customers_dataset;
-- -> 99,441

-- customer_unique_id数の確認 (o_customers_dataset)
select distinct count(customer_unique_id)
from o_customers_dataset;
-- -> 99,441

-- o_orders_datasetに利用日（≒初利用日）（morinaga 作成）
create temp table add_unique
as
select customer_unique_id,o.customer_id,o.order_id,o.order_purchase_timestamp
from o_orders_dataset o join o_customers_dataset c on (o.customer_id = c.customer_id)

select count(*)
from add_unique
--99441

drop table first_order;
create temp table first_order
as 
select customer_unique_id,min(order_purchase_timestamp)as 初利用
from add_unique
group by customer_unique_id;

drop table count_order;
create temp table count_order
as
select customer_unique_id,count(order_purchase_timestamp)as 初利用
from add_unique
group by customer_unique_id
order by 初利用 desc;


create temp table test as 
select distinct co.customer_unique_id, 初利用-1 as num, customer_state
from count_order co join o_customers_dataset ocd on (co.customer_unique_id=ocd.customer_unique_id) 
where 初利用 > 1
order by num desc;

select customer_state, count(*)
from test
group by customer_state
order by count desc;


-- 2回以降注文している
select sum(初利用-1)
from count_order
where 初利用 > 1;
-- -> 3,345

-- これをcsv出力
create table count_buy_two_over
as
select au.*, co.初利用 as count_buy
from add_unique au
	join (select * from count_order where 初利用 > 1) co on (au.customer_unique_id=co.customer_unique_id)
order by 初利用 desc, order_purchase_timestamp;

select count(*)
from first_order
--96096

create temp table a_un
as
select f.customer_unique_id,f.初利用,a.order_id
from first_order f join add_unique a on (f.初利用=a.order_purchase_timestamp) and (f.customer_unique_id=a.customer_unique_id) 







