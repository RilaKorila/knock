-- S-051: レシート明細データ（receipt）の売上エポック秒を日付型に変換し、「日」だけ取り出してレシート番号(receipt_no)、レシートサブ番号（receipt_sub_no）とともに10件表示せよ。
-- なお、「日」は0埋め2桁で取り出すこと。
select to_char(extract(day from to_timestamp(sales_epoch)), 'FM00') as sales_day, receipt_no, receipt_sub_no
from receipt
limit 10;

-- S-052: レシート明細データ（receipt）の売上金額（amount）を顧客ID（customer_id）ごとに合計の上、売上金額合計に対して2,000円以下を0、2,000円より大きい金額を1に二値化し、顧客ID、売上金額合計とともに10件表示せよ。
-- ただし、顧客IDが"Z"から始まるのものは非会員を表すため、除外して計算すること。
with amount_tbl as (
  select customer_id, sum(amount) as customer_amount
  from receipt
  where customer_id not like 'Z%'
  group by customer_id
)
select customer_id, customer_amount, (case when customer_amount > 2000 then  1 else 0 end) as over_2000
from amount_tbl
limit 10;

-- S-053: 顧客データ（customer）の郵便番号（postal_cd）に対し、東京（先頭3桁が100〜209のもの）を1、それ以外のものを0に二値化せよ。
-- さらにレシート明細データ（receipt）と結合し、全期間において売上実績のある顧客数を、作成した二値ごとにカウントせよ。
with customer_flg as(
select c.customer_id ,c.postal_cd, (case when cast(substr(c.postal_cd, 1, 3) as integer) between 100 and 209 then 1 else 0 end) as tokyo_flg
from customer c
),
saled_customer as(select cus.customer_id, sum(r.amount) as customer_amount, cus.tokyo_flg
from customer_flg cus
join receipt r on cus.customer_id = r.customer_id
group by cus.customer_id, cus.tokyo_flg)

-- S-054: 顧客データ（customer）の住所（address）は、埼玉県、千葉県、東京都、神奈川県のいずれかとなっている。
-- 都道府県毎にコード値を作成し、顧客ID、住所とともに10件表示せよ。値は埼玉県を11、千葉県を12、東京都を13、神奈川県を14とすること。

---- 正規表現を使う

select customer_id, address, 
  (case substring(address, '^.*?[都道府県]')
  when '埼玉県' then '11'
  when '千葉県' then '12'
  when '東京都' then '13'
  when '神奈川県' then '14' end) as prefecture_cd
from customer
limit 10;

---- LIKE句を使う
select customer_id, address, 
  (case
  when address like '埼玉県%' then '11'
  when address like '千葉県%' then '12'
  when address like '東京都%' then '13'
  when address like '神奈川県%' then '14'end) as prefecture_cd
from customer
limit 10;

-- S-055: レシート明細（receipt）データの売上金額（amount）を顧客ID（customer_id）ごとに合計し、その合計金額の四分位点を求めよ。その上で、顧客ごとの売上金額合計に対して以下の基準でカテゴリ値を作成し、顧客ID、売上金額合計とともに10件表示せよ。カテゴリ値は順に1〜4とする。
---- 最小値以上第1四分位未満 ・・・ 1を付与
---- 第1四分位以上第2四分位未満 ・・・ 2を付与
---- 第2四分位以上第3四分位未満 ・・・ 3を付与
---- 第3四分位以上 ・・・ 4を付与

with amount_table as(
  select customer_id, sum(amount) as sum_amount
  from receipt
  group by customer_id
),
percentail_table as (
    select 
    PERCENTILE_CONT(0.25) within group(order by sum_amount) as per_25,
    PERCENTILE_CONT(0.5) within group(order by sum_amount) as per_50,
    PERCENTILE_CONT(0.75) within group(order by sum_amount) as per_75
    from amount_table
)
select 
a.customer_id, a.sum_amount,
(case
  when sum_amount < per_25 then 1 
  when p.per_25 <= sum_amount and sum_amount < p.per_50 then 2
  when p.per_50 <= sum_amount and sum_amount < p.per_75 then 3
  when sum_amount >= p.per_50 then 4 end) as amount_flg
from percentail_table p, amount_table a
limit 10;

