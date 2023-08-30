-- 1. S-001: レシート明細データ（receipt）から全項目の先頭10件を表示し、どのようなデータを保有しているか目視で確認せよ。
select * from receipt limit 10;

-- 2. S-002: レシート明細データ（receipt）から売上年月日（sales_ymd）、顧客ID（customer_id）、商品コード（product_cd）、売上金額（amount）の順に列を指定し、10件表示せよ。

select sales_ymd, customer_id, product_cd, amount
from receipt
limit 10;


-- S-003: レシート明細データ（receipt）から売上年月日（sales_ymd）、顧客ID（customer_id）、商品コード（product_cd）、売上金額（amount）の順に列を指定し、10件表示せよ。ただし、sales_ymdをsales_dateに項目名を変更しながら抽出すること。

select sales_ymd as sales_date, customer_id, product_cd, amount
from receipt
limit 10;

-- 4. S-004: レシート明細データ（receipt）から売上日（sales_ymd）、顧客ID（customer_id）、商品コード（product_cd）、売上金額（amount）の順に列を指定し、以下の条件を満たすデータを抽出せよ。
-- 顧客ID（customer_id）が"CS018205000001"

select sales_ymd, customer_id, product_cd, amount
from receipt
where customer_id = 'CS018205000001';

-- 5. S-005: レシート明細データ（receipt）から売上日（sales_ymd）、顧客ID（customer_id）、商品コード（product_cd）、売上金額（amount）の順に列を指定し、以下の全ての条件を満たすデータを抽出せよ。
-- 顧客ID（customer_id）が"CS018205000001"
-- 売上金額（amount）が1,000以上

select sales_ymd, customer_id, product_cd, amount
from receipt
where customer_id = 'CS018205000001' and amount >= 1000;

-- 6. S-006: レシート明細データ（receipt）から売上日（sales_ymd）、顧客ID（customer_id）、商品コード（product_cd）、売上数量（quantity）、売上金額（amount）の順に列を指定し、以下の全ての条件を満たすデータを抽出せよ。
-- 顧客ID（customer_id）が"CS018205000001"
-- 売上金額（amount）が1,000以上または売上数量（quantity）が5以上

select sales_ymd, customer_id, product_cd, amount
from receipt
where customer_id = 'CS018205000001' and (amount >= 1000 or quantity > 5);

-- 7. S-007: レシート明細データ（receipt）から売上日（sales_ymd）、顧客ID（customer_id）、商品コード（product_cd）、売上金額（amount）の順に列を指定し、以下の全ての条件を満たすデータを抽出せよ。
-- 顧客ID（customer_id）が"CS018205000001"
-- 売上金額（amount）が1,000以上2,000以下

select sales_ymd, customer_id, product_cd, amount
from receipt
where customer_id = 'CS018205000001' and (amount >= 1000 and amount < 2000);

-- 8. S-008: レシート明細データ（receipt）から売上日（sales_ymd）、顧客ID（customer_id）、商品コード（product_cd）、売上金額（amount）の順に列を指定し、以下の全ての条件を満たすデータを抽出せよ。
-- 顧客ID（customer_id）が"CS018205000001"
-- 商品コード（product_cd）が"P071401019"以外

select sales_ymd, customer_id, product_cd, amount
from receipt
where customer_id = 'CS018205000001' and product_cd != 'P071401019';

-- 9. S-009: 以下の処理において、出力結果を変えずにORをANDに書き換えよ。
-- SELECT * FROM store WHERE NOT (prefecture_cd = '13' OR floor_area > 900)

select * from store
where prefecture_cd != '13' AND floor_area <= 900;

-- 10. S-010: 店舗データ（store）から、店舗コード（store_cd）が"S14"で始まるものだけ全項目抽出し、10件表示せよ。

select * 
from store
where store_cd like 'S14%'
limit 10;