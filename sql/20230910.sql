-- S-060: レシート明細データ（receipt）の売上金額（amount）を顧客ID（customer_id）ごとに合計し、売上金額合計を最小値0、最大値1に正規化して顧客ID、売上金額合計とともに10件表示せよ。
-- ただし、顧客IDが"Z"から始まるのものは非会員を表すため、除外して計算すること。

with amount_table as(
  select customer_id, sum(amount) as sum_amount
  from receipt
  where customer_id not like 'Z%'
  group by customer_id
),
stats_table as (
  select 
  min(sum_amount) as min_sales,
  max(sum_amount) as max_sales
  from amount_table
)
select customer_id, sum_amount, 1.0 *  (sum_amount - min_sales) /  (max_sales - min_sales) as nomalized_sales
from amount_table
cross join stats_table
limit 10; 

-- S-061: レシート明細データ（receipt）の売上金額（amount）を顧客ID（customer_id）ごとに合計し、売上金額合計を常用対数化（底10）して顧客ID、売上金額合計とともに10件表示せよ。
-- ただし、顧客IDが"Z"から始まるのものは非会員を表すため、除外して計算すること。
with sum_amount as(
select customer_id, sum(amount) as sum_amount
from receipt
where customer_id not like 'Z%'
group by customer_id
)
select customer_id, sum_amount, log(sum_amount) as log_amount
from sum_amount
limit 10;

-- S-062: レシート明細データ（receipt）の売上金額（amount）を顧客ID（customer_id）ごとに合計し、売上金額合計を自然対数化（底e）して顧客ID、売上金額合計とともに10件表示せよ。
-- ただし、顧客IDが"Z"から始まるのものは非会員を表すため、除外して計算すること。
with sum_amount as(
    select customer_id, sum(amount) as sum_amount
    from receipt
    where customer_id not like 'Z%'
    group by customer_id
)
select customer_id, sum_amount, ln(sum_amount) as log_amount
from sum_amount
limit 10;

-- S-063: 商品データ（product）の単価（unit_price）と原価（unit_cost）から各商品の利益額を算出し、結果を10件表示せよ。
select product_cd, unit_price, unit_cost, unit_price - unit_cost as unit_profit
from product
limit 10;

-- S-064: 商品データ（product）の単価（unit_price）と原価（unit_cost）から、各商品の利益率の全体平均を算出せよ。ただし、単価と原価には欠損が生じていることに注意せよ。
select avg((unit_price*1.0 - unit_cost) / unit_price) as profit_rate
from product

-- S-065: 商品データ（product）の各商品について、利益率が30%となる新たな単価を求めよ。ただし、1円未満は切り捨てること。そして結果を10件表示させ、利益率がおよそ30％付近であることを確認せよ。
-- ただし、単価（unit_price）と原価（unit_cost）には欠損が生じていることに注意せよ。
with new_unit_price_table as(
  select product_cd, unit_cost, unit_price, TRUNC(unit_cost / 0.7) as new_unit_price
  from product
  limit 10
)
select product_cd, unit_price, new_unit_price, (new_unit_price - unit_cost) / new_unit_price as new_profit_rate
from new_unit_price_table
limit 10;

-- S-066: 商品データ（product）の各商品について、利益率が30%となる新たな単価を求めよ。今回は、1円未満を丸めること（四捨五入または偶数への丸めで良い）。そして結果を10件表示させ、利益率がおよそ30％付近であることを確認せよ。
-- ただし、単価（unit_price）と原価（unit_cost）には欠損が生じていることに注意せよ。
with new_unit_price_table as(
  select product_cd, unit_cost, unit_price, round(unit_cost / 0.7) as new_unit_price
  from product
  limit 10
)
select product_cd, unit_price, new_unit_price, round((new_unit_price - unit_cost) / new_unit_price, 4) as new_profit_rate
from new_unit_price_table
limit 10;

-- S-067: 商品データ（product）の各商品について、利益率が30%となる新たな単価を求めよ。今回は、1円未満を切り上げること。そして結果を10件表示させ、利益率がおよそ30％付近であることを確認せよ。
-- ただし、単価（unit_price）と原価（unit_cost）には欠損が生じていることに注意せよ。
with new_unit_price_table as(
  select product_cd, unit_cost, unit_price, ceil(unit_cost / 0.7) as new_unit_price
  from product
  limit 10
)
select product_cd, unit_price, new_unit_price, round((new_unit_price - unit_cost) / new_unit_price, 4) as new_profit_rate
from new_unit_price_table
limit 10;

-- S-068: 商品データ（product）の各商品について、消費税率10％の税込み金額を求めよ。1円未満の端数は切り捨てとし、結果を10件表示せよ。
-- ただし、単価（unit_price）には欠損が生じていることに注意せよ。
select product_cd, unit_cost, unit_price, trunc(unit_price * 1.1) as unit_tex_included
from product
limit 10

-- S-069: レシート明細データ（receipt）と商品データ（product）を結合し、顧客毎に全商品の売上金額合計と、カテゴリ大区分コード（category_major_cd）が"07"（瓶詰缶詰）の売上金額合計を計算の上、両者の比率を求めよ。
-- 抽出対象はカテゴリ大区分コード"07"（瓶詰缶詰）の売上実績がある顧客のみとし、結果を10件表示せよ。
with category7 as(
  select r.customer_id, sum(r.amount) as sum_category7
  from receipt r
  join product p on r.product_cd = p.product_cd
  where p.category_major_cd = '07'
  group by  r.customer_id
),
sum_all as(
  select customer_id, sum(amout) as sum_amount
  from receipt
  group by customer_id
)

select s.customer_id, c7.sum_category7, s.sum_amount
from category7 c7, sum_all s
limit 10;

-- S-070: レシート明細データ（receipt）の売上日（sales_ymd）に対し、顧客データ（customer）の会員申込日（application_date）からの経過日数を計算し、顧客ID（customer_id）、売上日、会員申込日とともに10件表示せよ（
-- sales_ymdは数値、application_dateは文字列でデータを保持している点に注意）。
with distinct_table as (
  select distinct customer_id, sales_ymd
  from receipt
)
select c.customer_id, d.sales_ymd, c.application_date, extract( day from to_timestamp(cast(d.sales_ymd as varchar), 'YYYYMMDD') - to_timestamp(c.application_date, 'YYYYMMDD') ) as passed_days
from distinct_table d
join customer c on c.customer_id = d.customer_id
limit 10;
