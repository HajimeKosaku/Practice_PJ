# プロジェクト実践（チームA）  
追加次第、記入していく。

## プログラム
### SQL 
- import_olist_dataset.sel  
  データセットの読み込み
- export_products_dataset.sql  
　商品のデシル分析結果の出力PGM　
- CreateTable_CustomerDecileAnalysis.sql  
　購入者の注文総額をもとにデシル分析の結果出力PGM
- check_repeater.sql  
  リピーターの確認用PGM

### Python
- GetOlistData.ipynb  
　データと見込み用のPGM（メンター作成）    
- PurchasingTrendAnalysis_corr_pca.ipynb  
　商品の各変数の相関を調査
- DecileAnalysis_Customer.ipynb  
　CreateTable_CustomerDecileAnalysis.sqlにより得られたデータをもとに、以下の項目を可視化
    - 地域
    - 支払い方法
    - カテゴリ

## データ
- product_dataset_decile.csv  
　export_products_dataset.sqlの出力結果
- product_dataset_decile5.csv  
　export_products_dataset.sqlの出力結果（分割数5）
- customer_dataset_decile.csv  
　CreateTable_CustomerDecileAnalysis.sqlの出力結果

