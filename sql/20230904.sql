-- S-041: レシート明細データ（receipt）の売上金額（amount）を日付（sales_ymd）ごとに集計し、前回売上があった日からの売上金額増減を計算せよ。そして結果を10件表示せよ。
with sum_amount_group_by_date as (
  select sales_ymd, sum(amount) as sum_amount
  from receipt
  group by sales_ymd),
lag_amount_group_by_date as (
  select sales_ymd, lag(sales_ymd, 1) over (order by sales_ymd) as lag_sales_ymd, sum_amount, lag(sum_amount, 1) over (order by sales_ymd) as lag_sum_amount
  from sum_amount_group_by_date
)
select sales_ymd, lag_sales_ymd, sum_amount, lag_sum_amount, sum_amount - lag_sum_amount as diff
from lag_amount_group_by_date 
order by sales_ymd
limit 10;


-- S-042: レシート明細データ（receipt）の売上金額（amount）を日付（sales_ymd）ごとに集計し、
-- 各日付のデータに対し、前回、前々回、3回前に売上があった日のデータを結合せよ。そして結果を10件表示せよ。
with sum_amount_group_by_date as (
  select sales_ymd, sum(amount) as sum_amount
  from receipt
  group by sales_ymd),
lag_amount_group_by_date as (
  select 
  sales_ymd, 
  sum_amount,
  lag(sales_ymd, 1) over (order by sales_ymd) as lag_sales_ymd,
  lag(sales_ymd, 2) over (order by sales_ymd) as lag2_sales_ymd,
  lag(sales_ymd, 3) over (order by sales_ymd) as lag3_sales_ymd,
  lag(sum_amount, 1) over (order by sales_ymd) as lag_sum_amount,
  lag(sum_amount, 2) over (order by sales_ymd) as lag2_sum_amount,
  lag(sum_amount, 3) over (order by sales_ymd) as lag3_sum_amount
  from sum_amount_group_by_date
)
select sales_ymd, lag_sales_ymd, lag2_sales_ymd, lag2_sum_amount, lag3_sales_ymd, lag3_sum_amount
from lag_amount_group_by_date
where  lag3_sales_ymd is not null
order by sales_ymd
limit 10;


-- S-043: レシート明細データ（receipt）と顧客データ（customer）を結合し、性別コード（gender_cd）と年代（ageから計算）ごとに売上金額（amount）を合計した売上サマリデータを作成せよ。
-- 性別コードは0が男性、1が女性、9が不明を表すものとする。
-- ただし、項目構成は年代、女性の売上金額、男性の売上金額、性別不明の売上金額の4項目とすること（縦に年代、横に性別のクロス集計）。また、年代は10歳ごとの階級とすること。

with summary_table as (
  select sum(r.amount) as sum_amout, trunc(c.age / 10) * 10 as era, gender_cd
  from customer c
  join  receipt r on r.customer_id = c.customer_id
  group by era, c.gender_cd
)

select era,  
sum(case when gender_cd = '0' then sum_amout else 0 end) as male,
sum(case when gender_cd = '1' then sum_amout else 0 end) as female,
sum(case when gender_cd = '9' then sum_amout else 0 end) as unknown
from summary_table
group by era
order by era;


-- LAG, LEAD: 前後の行を持って来れる関数
    -- https://qiita.com/kota_fujimura/items/cff732bb9acb47510a03