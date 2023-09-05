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



-- union: 重複を削除して合体
-- union all: 重複を削除せず合体(=重複するレコードが存在)