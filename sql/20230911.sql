-- S-071: レシート明細データ（receipt）の売上日（sales_ymd）に対し、顧客データ（customer）の会員申込日（application_date）からの経過月数を計算し、顧客ID（customer_id）、売上日、会員申込日とともに10件表示せよ
-- （sales_ymdは数値、application_dateは文字列でデータを保持している点に注意）。1ヶ月未満は切り捨てること。
with distinct_table as (
  select distinct customer_id, sales_ymd
  from receipt
)
select c.customer_id, d.sales_ymd, c.application_date, 
trunc(extract( day from to_timestamp(cast(d.sales_ymd as varchar), 'YYYYMMDD') - to_timestamp(c.application_date, 'YYYYMMDD') ) / 30) as passed_months
from distinct_table d
join customer c on c.customer_id = d.customer_id
limit 10;

-- S-072: レシート明細データ（receipt）の売上日（sales_ymd）に対し、顧客データ（customer）の会員申込日（application_date）からの経過年数を計算し、顧客ID（customer_id）、売上日、会員申込日とともに10件表示せよ
-- （sales_ymdは数値、application_dateは文字列でデータを保持している点に注意）。1年未満は切り捨てること。
with distinct_table as (
  select distinct customer_id, sales_ymd
  from receipt
)
select c.customer_id, d.sales_ymd, c.application_date, 
trunc(extract( day from to_timestamp(cast(d.sales_ymd as varchar), 'YYYYMMDD') - to_timestamp(c.application_date, 'YYYYMMDD') ) / 365) as passed_months
from distinct_table d
join customer c on c.customer_id = d.customer_id
limit 10;


-- S-073: レシート明細データ（receipt）の売上日（sales_ymd）に対し、顧客データ（customer）の会員申込日（application_date）からのエポック秒による経過時間を計算し、顧客ID（customer_id）、売上日、会員申込日とともに10件表示せよ（なお、sales_ymdは数値、application_dateは文字列でデータを保持している点に注意）。
-- なお、時間情報は保有していないため各日付は0時0分0秒を表すものとする。
with distinct_table as (
  select distinct customer_id, sales_ymd
  from receipt
)
select c.customer_id, d.sales_ymd, c.application_date, 
extract( epoch from to_timestamp(cast(d.sales_ymd as varchar), 'YYYYMMDD') - to_timestamp(c.application_date, 'YYYYMMDD') ) as passed_months
from distinct_table d
join customer c on c.customer_id = d.customer_id
limit 10;

-- ここから先は統計的な知識になりそうなので一旦ストップ