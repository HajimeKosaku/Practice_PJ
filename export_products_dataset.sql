/*
顧客の購買傾向を見るために、各商品が何回売れているかを集計して、o_products_datasetと紐付け
*/
create temp table count_products 
as
select product_id, count(*) as count_sold
from o_order_items_dataset
group by product_id;


-- ctile(n) n:分割数
create table products_dataset_decile
as
select opd.*, cp.count_sold, ntile(5) over (order by cp.count_sold desc) as decile 
from o_products_dataset opd 
	left outer join count_products cp on (opd.product_id=cp.product_id)
order by count_sold desc;

--copy products_dataset_add_count to 'C:\Users\HAJIME KOSAKU\Desktop\prodcts_dataset.csv' with csv delimiter ',';