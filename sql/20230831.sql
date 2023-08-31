-- S-010: 店舗データ（store）から、店舗コード（store_cd）が"S14"で始まるものだけ全項目抽出し、10件表示せよ。

select * 
from store
where store_cd like 'S14%'
limit 10;

-- S-011: 顧客データ（customer）から顧客ID（customer_id）の末尾が1のものだけ全項目抽出し、10件表示せよ。
select * from customer
where customer_id like '%1'
limit 10;

-- S-012: 店舗データ（store）から、住所 (address) に"横浜市"が含まれるものだけ全項目表示せよ。
select * from store
where address like '%横浜市%';

-- S-013: 顧客データ（customer）から、ステータスコード（status_cd）の先頭がアルファベットのA〜Fで始まるデータを全項目抽出し、10件表示せよ。
select * from customer
where status_cd ~ '[A-F]+.*'
limit 10;

---- パターン2: 先頭がAからFのどれか
select * from customer
where status_cd ~ '^[A-F]'
limit 10;

-- S-014: 顧客データ（customer）から、ステータスコード（status_cd）の末尾が数字の1〜9で終わるデータを全項目抽出し、10件表示せよ。
select * from customer
where status_cd ~ '[1-9]$'
limit 10;

-- S-015: 顧客データ（customer）から、ステータスコード（status_cd）の先頭がアルファベットのA〜Fで始まり、末尾が数字の1〜9で終わるデータを全項目抽出し、10件表示せよ。
select * from customer
where status_cd ~ '^[A-F].*[1-9]$'
limit 10;

-- S-016: 店舗データ（store）から、電話番号（tel_no）が3桁-3桁-4桁のデータを全項目表示せよ。
select * from store
where tel_no ~ '[0-9]{3}\-[0-9]{3}\-[0-9]{4}';

-- S-017: 顧客データ（customer）を生年月日（birth_day）で高齢順にソートし、先頭から全項目を10件表示せよ。
select * from customer
order by birth_day
limit 10

-- S-018: 顧客データ（customer）を生年月日（birth_day）で若い順にソートし、先頭から全項目を10件表示せよ。
select * from customer
order by birth_day desc
limit 10;

-- S-019: レシート明細データ（receipt）に対し、1件あたりの売上金額（amount）が高い順にランクを付与し、先頭から10件表示せよ。項目は顧客ID（customer_id）、売上金額（amount）、付与したランクを表示させること。
-- なお、売上金額（amount）が等しい場合は同一順位を付与するものとする
select customer_id, amount, RANK() OVER (ORDER BY amount DESC) AS rank
from receipt
limit 10;

-- S-020: レシート明細データ（receipt）に対し、1件あたりの売上金額（amount）が高い順にランクを付与し、先頭から10件表示せよ。
-- 項目は顧客ID（customer_id）、売上金額（amount）、付与したランクを表示させること。なお、売上金額（amount）が等しい場合でも別順位を付与すること。
select customer_id, amount, ROW_NUMBER() OVER (ORDER BY amount DESC) AS rank
from receipt
limit 10;


-- ランク付けの関数の違い
-- RANK(): 同立順位が来た後、そのぶんのランクを下げる ex. 1, 2, 3, 4, 4, 6
-- DENSE_RANK(): 同立順位がきても、そのぶんのランクを下げない ex. 1, 2, 3, 4, 4, 5
-- NUM_ROWS(): 同立順位がには、無理やりランキングをつける ex. 1, 2, 3, 4, 5, 6