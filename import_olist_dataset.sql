/*
テーブルの定義
*/
-- 購入者のデータセット
create table o_customers_dataset(
	customer_id VARCHAR(50), -- 購入者ID（主キー）
	customer_unique_id VARCHAR(50), -- ???
	customer_zip_code_prefix NUMERIC, -- 住所ID（外部キー:o_geolocation_dataset）
	customer_city VARCHAR(50), -- 州
	customer_state VARCHAR(10) -- 州の略称
);

-- 住所のデータセット
create table o_geolocation_dataset(
	geolocation_zip_code_prefix NUMERIC, -- 主キー
	geolocation_lat NUMERIC, -- 緯度
	geolocation_lng NUMERIC, -- 経度
	geolocation_city VARCHAR(50), -- 州
	geolocation_state VARCHAR(10) -- 州の略称
);

-- 注文（商品関連）のデータセット
create table o_order_items_dataset(
	order_id VARCHAR(50), -- 注文ID（外部キー:o_orders_dataset）
	order_item_id NUMERIC, -- 注文の中の商品ID
	product_id VARCHAR(50), -- 商品ID（外部キー:o_products_dataset）
	seller_id VARCHAR(50), -- 小売業者ID（外部:o_seller_dataset）
	shipping_limit_date TIMESTAMP, -- 注文した日時
	price NUMERIC, -- 値段（?）
	freight_value NUMERIC -- 送料
);

-- 購入情報のデータセット
create table o_order_payments_dataset(
	order_id VARCHAR(50), -- 注文ID（外部キー:o_orders_dataset）
	payment_sequential NUMERIC, -- 不明（？）
	payment_type VARCHAR(50), -- 支払方法
	payment_installments NUMERIC, -- 分割回数
	payment_value NUMERIC -- 支払金額
);

-- レビューのデータセット
create table o_order_reviews_dataset(
	review_id VARCHAR(50), -- レビューID（主キー）
	order_id VARCHAR(50), -- 注文ID（外部キー:o_orders_dataset）
	review_score NUMERIC, -- スコア
	review_comment_title VARCHAR(50), -- コメントのタイトル
	review_comment_message VARCHAR(500), -- コメント内容
	review_creation_date TIMESTAMP, -- 作成日
	review_answer_timestamp	TIMESTAMP -- （店舗側の）解答日時（？）
);

-- 注文（配送関連）のデータセット
create table o_orders_dataset(
	order_id VARCHAR(50), -- 注文ID（主キー）
	customer_id	VARCHAR(50), -- 購入者ID（外部キー:o_customers_dataset）
	order_status VARCHAR(20), -- 発送状況
	order_purchase_timestamp TIMESTAMP, -- 購入時間
	order_approved_at TIMESTAMP, -- 決済承認時間
	order_delivered_carrier_date TIMESTAMP, -- 発送日
	order_delivered_customer_date TIMESTAMP, -- 到着日
	order_estimated_delivery_date TIMESTAMP -- 到着予定日
);

-- 商品のデータセット
create table o_products_dataset(
	product_id VARCHAR(50), -- 商品ID（主キー）
	product_category_name VARCHAR(50), -- カテゴリ名
	product_name_lenght NUMERIC, -- 商品名の長さ
	product_description_lenght NUMERIC, -- 商品の説明の長さ
	product_photos_qty NUMERIC, -- 写真の枚数
	product_weight_g NUMERIC, -- 商品の重さ（g）
	product_length_cm NUMERIC, -- 商品の横の長さ（cm）
	product_height_cm NUMERIC, -- 商品の高さ（cm）
	product_width_cm NUMERIC -- 商品の幅（cm）
);

-- 小売業者のデータセット
create table o_sellers_dataset(
	seller_id VARCHAR(50), -- 小売業者ID（主キー）
	seller_zip_code_prefix NUMERIC, -- 住所ID（外部キー:o_geolocation_dataset）
	seller_city VARCHAR(50), -- 州
	seller_state VARCHAR(10) -- 州の略称
);

-- カテゴリ名の英語対応
create table o_product_category(
	product_category_name VARCHAR(50), -- カテゴリ名
	product_category_name_english VARCHAR(50) -- カテゴリ名（英語）
);

/*
csvファイルのインポート
*/
copy o_customers_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_customers_dataset.csv' with csv delimiter ',' header;  
copy o_geolocation_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_geolocation_dataset.csv' with csv delimiter ',' header;  
copy o_order_items_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_order_items_dataset.csv' with csv delimiter ',' header;  
copy o_order_payments_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_order_payments_dataset.csv' with csv delimiter ',' header;  
copy o_order_reviews_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_order_reviews_dataset.csv' with csv delimiter ',' header;  
copy o_orders_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_orders_dataset.csv' with csv delimiter ',' header;  
copy o_products_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_products_dataset.csv' with csv delimiter ',' header;  
copy o_sellers_dataset from 'C:\Program Files\PostgreSQL\12\data\olist_sellers_dataset.csv' with csv delimiter ',' header;  
copy o_product_category from 'C:\Program Files\PostgreSQL\12\data\product_category_name_translation.csv' with csv delimiter ',' header;  

/*
確認
*/
select * from o_customers_dataset;
select * from o_geolocation_dataset;
select * from o_order_items_dataset;
select * from o_order_payments_dataset;
select * from o_order_reviews_dataset;
select * from o_orders_dataset;
select * from o_products_dataset;
select * from o_sellers_dataset;
select * from o_product_category;
