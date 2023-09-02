-- S-021: レシート明細データ（receipt）に対し、件数をカウントせよ。
select count(*) from receipt;

-- S-022: レシート明細データ（receipt）の顧客ID（customer_id）に対し、ユニーク件数をカウントせよ。
select count(distinct customer_id) from receipt;

-- S-023: レシート明細データ（receipt）に対し、店舗コード（store_cd）ごとに売上金額（amount）と売上数量（quantity）を合計せよ。
select count(amount) as sum_amount, count(quantity) as sum_quantity from receipt
group by store_cd;

-- S-024: レシート明細データ（receipt）に対し、顧客ID（customer_id）ごとに最も新しい売上年月日（sales_ymd）を求め、10件表示せよ。
select customer_id, max(sales_ymd) from receipt
group by customer_id
limit 10;

-- S-025: レシート明細データ（receipt）に対し、顧客ID（customer_id）ごとに最も古い売上年月日（sales_ymd）を求め、10件表示せよ。
select customer_id, min(sales_ymd)
from receipt
group by customer_id
limit 10;

-- S-026: レシート明細データ（receipt）に対し、顧客ID（customer_id）ごとに最も新しい売上年月日（sales_ymd）と古い売上年月日を求め、両者が異なるデータを10件表示せよ。
select customer_id, min(sales_ymd) as old_sales_ymd, max(sales_ymd) as new_sales_ymd
from receipt
group by customer_id
having min(sales_ymd) != max(sales_ymd)
limit 10;

-- S-027: レシート明細データ（receipt）に対し、店舗コード（store_cd）ごとに売上金額（amount）の平均を計算し、降順でTOP5を表示せよ。
select store_cd, avg(amount) as mean
from receipt
group by store_cd
order by mean desc
limit 5;

-- S-028: レシート明細データ（receipt）に対し、店舗コード（store_cd）ごとに売上金額（amount）の中央値を計算し、降順でTOP5を表示せよ。
select store_cd, PERCENTILE_CONT(0.5) within group (order by receipt.amount) as median
from receipt
group by store_cd
order by median desc
limit 5;

-- S-029: レシート明細データ（receipt）に対し、店舗コード（store_cd）ごとに商品コード（product_cd）の最頻値を求め、10件表示させよ。
---- コード例1: window関数や分析関数で最頻値を集計する


---- コード例2: MODE()を使う簡易ケース（早いが最頻値が複数の場合は一つだけ選ばれる）
select store_cd, MODE() WITHIN GROUP(ORDER BY product_cd) as mode
from receipt
group by store_cd
order by store_cd desc
limit 5;

-- S-030: レシート明細データ（receipt）に対し、店舗コード（store_cd）ごとに売上金額（amount）の分散を計算し、降順で5件表示せよ。
select store_cd, variance(amount) as var
from receipt
group by store_cd
order by store_cd desc
limit 5;

-- https://www.postgresql.jp/document/7.4/html/functions-aggregate.html