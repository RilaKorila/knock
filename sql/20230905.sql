-- S-044: 043で作成した売上サマリデータ（sales_summary）は性別の売上を横持ちさせたものであった。このデータから性別を縦持ちさせ、年代、性別コード、売上金額の3項目に変換せよ。
-- ただし、性別コードは男性を"00"、女性を"01"、不明を"99"とする。
select era, '0' as gender_cd, male as amount
from sales_summary
union all

select era, '1' as gender_cd, female as amount
from sales_summary
union all

select era, '9' as gender_cd, unknown as amount
from sales_summary;

-- S-045: 顧客データ（customer）の生年月日（birth_day）は日付型でデータを保有している。
-- これをYYYYMMDD形式の文字列に変換し、顧客ID（customer_id）とともに10件表示せよ。
select customer_id, to_char(birth_day, 'YYYYMMDD') as birth_day
from customer
limit 10;

-- S-046: 顧客データ（customer）の申し込み日（application_date）はYYYYMMDD形式の文字列型でデータを保有している。
-- これを日付型に変換し、顧客ID（customer_id）とともに10件表示せよ。
select customer_id, to_date(application_date, 'YYYYMMDD') as application_date
from customer
limit 10;

-- S-047: レシート明細データ（receipt）の売上日（sales_ymd）はYYYYMMDD形式の数値型でデータを保有している。
-- これを日付型に変換し、レシート番号(receipt_no)、レシートサブ番号（receipt_sub_no）とともに10件表示せよ。
select customer_id, to_date(cast(sales_ymd as VARCHAR), 'YYYYMMDD') as sales_ymd, receipt_no, receipt_sub_no
from receipt
limit 10;

-- S-048: レシート明細データ（receipt）の売上エポック秒（sales_epoch）は数値型のUNIX秒でデータを保有している。
-- これを日付型に変換し、レシート番号(receipt_no)、レシートサブ番号（receipt_sub_no）とともに10件表示せよ。
select to_timestamp(sales_epoch), receipt_no, receipt_sub_no
from receipt
limit 10;

-- S-049: レシート明細データ（receipt）の売上エポック秒（sales_epoch）を日付型に変換し、
-- 「年」だけ取り出してレシート番号(receipt_no)、レシートサブ番号（receipt_sub_no）とともに10件表示せよ。
select extract(year from to_timestamp(sales_epoch)) as year, receipt_no, receipt_sub_no
from receipt
limit 10;

-- S-050: レシート明細データ（receipt）の売上エポック秒（sales_epoch）を日付型に変換し、「月」だけ取り出してレシート番号(receipt_no)、レシートサブ番号（receipt_sub_no）とともに10件表示せよ。
-- なお、「月」は0埋め2桁で取り出すこと。
select to_char(extract(month from to_timestamp(sales_epoch)), 'FM00') as month, receipt_no, receipt_sub_no
from receipt
limit 10;


-- union: 重複を削除して合体
-- union all: 重複を削除せず合体(=重複するレコードが存在)