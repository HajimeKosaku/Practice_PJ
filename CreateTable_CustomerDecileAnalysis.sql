/*
顧客の注文総額に着目してデシル分析
 ・地域
 ・支払い方法
 ・商品カテゴリ
 に着目して構成比を可視化したい
*/

/*
カテゴリの前処理
*/
-- カテゴリの確認
select distinct product_category_name
from o_products_dataset
where product_category_name not in (select product_category_name from o_product_category) 
-- -> "portateis_cozinha_e_preparadores_de_alimentos", "pc_gamer" が不足

-- 不足分のカテゴリの追加
/*
insert into o_product_category
values
	('portateis_cozinha_e_preparadores_de_alimentos', 'portable_kitchen_and_food_preparers'), 
	('pc_gamer', 'pc_gamer');
*/

-- 商品のカテゴリを英語版と対応
-- drop table products_category_english;
create temp table products_category_english
as
select product_id, opd.product_category_name, opc.product_category_name_english
from o_products_dataset opd 
	left outer join o_product_category opc on (opd.product_category_name=opc.product_category_name);

-- product_category_name_englishの確認
select distinct product_category_name_english
from products_category_english
-- -> null混入

/*
最頻値の集計
*/

-- order_idごとに支払い方法の最頻値の集計
create temp table order_payment
as 
select ooid.order_id, mode() within group (order by payment_type) as mode_payment
from o_order_items_dataset ooid 
	join o_order_payments_dataset oopd on (ooid.order_id=oopd.order_id)
group by ooid.order_id;

-- order_idごとにカテゴリの最頻値の集計
create temp table order_category
as
select ooid.order_id, mode() within group (order by product_category_name_english) as mode_category
from o_order_items_dataset ooid
	join o_products_dataset opd on (ooid.product_id=opd.product_id)
	join products_category_english pce on (opd.product_id=pce.product_id)
group by ooid.order_id;

-- customer_id基準でstete, price, mode_payment, mode_categoryの追加
--drop table order_add_dataset;
create temp table order_add_dataset
as
select ood.order_id, customer_unique_id, -- id
		customer_zip_code_prefix, customer_city, customer_state, -- 住所
		price, -- 金額
		mode_payment,
		mode_category
from o_orders_dataset ood 
	join o_customers_dataset ocd on (ood.customer_id=ocd.customer_id)
	join o_order_items_dataset ooid on (ood.order_id=ooid.order_id)
	join order_payment op on (ood.order_id=op.order_id)
	join order_category oc on (ood.order_id=oc.order_id);
	
-- unique_idごとに注文総額の集計
-- drop table unique_sum_price;
create temp table unique_sum_price
as
select customer_unique_id, sum(price) as sum_price
from order_add_dataset
group by customer_unique_id
order by sum_price;

-- unique_idと支払い方法, カテゴリの最頻値を紐付け
create temp table mode_dataset
as
select customer_unique_id, 
		mode() within group (order by mode_payment) as unique_payment,
		mode() within group (order by mode_category) as unique_category
from order_add_dataset oad
group by customer_unique_id;

-- デシル分析結果
create table customer_dataset_decile
as
select distinct oad.customer_unique_id, 
		customer_zip_code_prefix,
		customer_city,
		customer_state,
		unique_payment,
		unique_category, 
		usp.sum_price,
		ntile(10) over (order by usp.sum_price desc) as decile
from order_add_dataset oad
	join mode_dataset md on (oad.customer_unique_id=md.customer_unique_id)
	join unique_sum_price usp on (oad.customer_unique_id=usp.customer_unique_id)
order by sum_price desc;


