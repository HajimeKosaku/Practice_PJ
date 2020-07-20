/*
顧客の購買傾向を見るために、各商品が何回売れているかを集計して、o_products_datasetと紐付け
*/
create temp table count_products 
as
select product_id, count(*) as count_sold
from o_order_items_dataset
group by product_id;

-- ntile(n) n:分割数
create table products_dataset_decile
as
select opd.*, cp.count_sold, ntile(5) over (order by cp.count_sold desc) as decile 
from o_products_dataset opd 
	left outer join count_products cp on (opd.product_id=cp.product_id)
order by count_sold desc;


/*
顧客の購買傾向を見るために、各商品が何回売れているかを集計して、o_products_datasetと紐付け
*/
create temp table count_products_price 
as
select product_id, sum(price) as sum_price
from o_order_items_dataset
group by product_id;


-- ntile(n) n:分割数
create table products_dataset_decile_sumprice
as
select opd.*, cp.sum_price, ntile(10) over (order by cp.sum_price desc) as decile 
from o_products_dataset opd 
	left outer join count_products_price cp on (opd.product_id=cp.product_id)
order by sum_price desc;