-- S-031: レシート明細データ（receipt）に対し、店舗コード（store_cd）ごとに売上金額（amount）の標準偏差を計算し、降順で5件表示せよ。
select store_cd, stddev(amount) as std
from receipt
group by store_cd
order by store_cd desc
limit 5;

-- S-032: レシート明細データ（receipt）の売上金額（amount）について、25％刻みでパーセンタイル値を求めよ。
select 
PERCENTILE_CONT(0.25) within group(order by amount) as per_25,
PERCENTILE_CONT(0.5) within group(order by amount) as per_50,
PERCENTILE_CONT(0.75) within group(order by amount) as per_75,
PERCENTILE_CONT(1.0) within group(order by amount) as per_100
from receipt;

-- S-033: レシート明細データ（receipt）に対し、店舗コード（store_cd）ごとに売上金額（amount）の平均を計算し、330以上のものを抽出せよ。

---- 解法1: サブクエリ
select store_cd, avg
from (select store_cd, avg(amount) as avg
from receipt
group by store_cd) AS subquery
where avg >= 330;

---- 解法2: having
select store_cd, avg(amount) as avg
from receipt
group by store_cd
having avg(amount) >= 330;

-- S-034: レシート明細データ（receipt）に対し、顧客ID（customer_id）ごとに売上金額（amount）を合計して全顧客の平均を求めよ。ただし、顧客IDが"Z"から始まるものは非会員を表すため、除外して計算すること。
with customer_amount as(
select customer_id, sum(amount) as sum_amount
from receipt
where customer_id not like 'Z%'
group by customer_id
)
select avg(sum_amount)
from customer_amount;

-- S-035: レシート明細データ（receipt）に対し、顧客ID（customer_id）ごとに売上金額（amount）を合計して
-- 全顧客の平均を求め、平均以上に買い物をしている顧客を抽出し、10件表示せよ。
-- ただし、顧客IDが"Z"から始まるものは非会員を表すため、除外して計算すること。
with customer_amount as(
  select customer_id, sum(amount) as sum_amount
  from receipt
  where customer_id not like 'Z%'
  group by customer_id
)
select customer_id, sum_amount
from customer_amount
where sum_amount >= (
  select avg(sum_amount)
  from customer_amount
)
limit 10;

-- S-036: レシート明細データ（receipt）と店舗データ（store）を内部結合し、
-- レシート明細データの全項目と店舗データの店舗名（store_name）を10件表示せよ。
select r.*, s.store_name
from receipt r
join store s on r.store_cd = s.store_cd
limit 10;

-- S-037: 商品データ（product）とカテゴリデータ（category）を内部結合し、商品データの全項目とカテゴリデータのカテゴリ小区分名（category_small_name）を10件表示せよ。
select p.*, c.category_small_name
from product p
join category c on p.category_major_cd = c.category_major_cd
limit 10;

-- S-038: 顧客データ（customer）とレシート明細データ（receipt）から、顧客ごとの売上金額合計を求め、10件表示せよ。
-- ただし、売上実績がない顧客については売上金額を0として表示させること。
-- また、顧客は性別コード（gender_cd）が女性（1）であるものを対象とし、非会員（顧客IDが"Z"から始まるもの）は除外すること。
with customer_amount_history as
(select c.gender_cd as gender_cd, c.customer_id as customer_id, r.amount as amount
from customer c
left outer join  receipt r on c.customer_id = r.customer_id)
select customer_id, coalesce(sum(amount), 0)
from customer_amount_history
where gender_cd = '1' and customer_id not like 'Z%'
group by customer_id
limit 10;
 
--  S-039: レシート明細データ（receipt）から、売上日数の多い顧客の上位20件を抽出したデータと、売上金額合計の多い顧客の上位20件を抽出したデータをそれぞれ作成し、
-- さらにその2つを完全外部結合せよ。
-- ただし、非会員（顧客IDが"Z"から始まるもの）は除外すること。
with much_times as(
  select r.customer_id, count(distinct sales_ymd) as count_days
  from receipt r
  where customer_id not like 'Z%'
  group by customer_id
  order by count_days desc
  limit 20
),
much_amount as(
  select r.customer_id, sum(amount) as sum_amounts
  from receipt r
  where customer_id not like 'Z%'
  group by customer_id
  order by sum_amounts desc
  limit 20
)
select COALESCE(t.customer_id, a.customer_id) as customer_id, t.count_days, a.sum_amounts
from much_times t
full outer join much_amount a on a.customer_id = t.customer_id

-- S-040: 全ての店舗と全ての商品を組み合わせたデータを作成したい。
-- 店舗データ（store）と商品データ（product）を直積し、件数を計算せよ。
select count(*)
from store
cross join product
-- -> 531590

---- 確認 ----
select count(*)
from store
-- -> 53
select count(*)
from product
-- -> 10030

---- -> 53 * 10030 = 531590

-- with句は先に評価される
-- with テーブル名 as (SQL); で先に実行するsqlを指定できる
-- 直積: cross join
    -- inner join とも違って、結合条件が不要
    -- https://zenn.dev/bules/articles/cbdd00d46e1367