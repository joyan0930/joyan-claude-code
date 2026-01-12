# データプラットフォーム刷新

## 戦略的位置づけ
freeeの全プロダクトを横断するデータ基盤。
FY25の重点施策として、セルフサービス化とコスト最適化を推進。

## ビジネス目標
- データ活用のTime-to-Insight を 50% 短縮
- BigQuery コストを 30% 削減
- 非エンジニアのセルフサービス率を 40% に

## 技術コンテキスト
### 現状アーキテクチャ
- データレイク: BigQuery
- ETL: Dataform + Cloud Composer
- BI: Looker (Looker Cloud Core)
- カタログ: OpenMetadata (導入中)

### 制約事項
- レガシー DWH (Redshift) からの移行は FY25 Q3 完了予定
- SOC2 準拠のためのデータ分類必須

## 意思決定の原則
- コスト効率 > 機能網羅性
- 自動化 > 手動運用
- ドキュメント駆動

## 注意すべきリスク
- Redshift 移行遅延による並行運用コスト
- Looker ライセンスコスト増
