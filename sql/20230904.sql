-- S-041: レシート明細データ（receipt）の売上金額（amount）を日付（sales_ymd）ごとに集計し、前回売上があった日からの売上金額増減を計算せよ。そして結果を10件表示せよ。


-- LAG, LEAD: 前後の行を持って来れる関数
    -- https://qiita.com/kota_fujimura/items/cff732bb9acb47510a03