# アプリ名：『Resonance-MKT』
<br>

### 目次
- [サービスURL](#-サービスurl)
- [サービス概要](#-サービス概要)
- [サービス開発の背景](#-サービス開発の背景)
- [使用技術](#使用技術)
- [機能一覧](#-機能一覧)
- [画面遷移図](#画面遷移図)
- [ER図](#er図)<br>
<br>

### サービスURL
https://rails-reso-mkt.onrender.com/<br>
<br>

### サービス概要
「レゾナンス」というゲーム内で都市毎に商品の価格情報を共有できるアプリです。<br>
<br>
~具体的には~<br>
「レゾナンス」というゲームをざっくり説明すると、鉄道を軸に各都市で商品の売買を行い利益をあげるゲームです。<br>
そして私が作成したアプリを説明する上で、重要なゲームの仕様は以下の2点です。<br>
**・「各都市毎に商品の売買価格が異なり、時間経過でも変動する」**
**・「価格情報は全ユーザーで共通である」**<br>
<br>
この仕様により「今この都市に行くならどの商品が高く売れるのか」、「今この商品を売るならどの都市が高いのか」ということを知りたいと思うことがあり、それらの情報を共有できるように本アプリを作りました。
<br>

### サービス開発の背景
元々少数でも利用される可能性のあるアプリを作りたいと思い、マイナーで特殊な物に絞って作れる何かを考えていました。<br>
そこで新しくリリースされたマイナーゲームで何か不便なところはないかと思案しこのアプリを作りました。<br>
<br>

### 使用技術
| カテゴリー	| 使用技術 |
| ---- | ---- |
| サーバーサイド | Ruby(Ruby on Rails) |
| フロントエンド | Ruby(Ruby on Rails)・Hotwire |
| CSSフレームワーク | Tailwindcss |
| インフラ | Render |
| データベース | PostgreSQL |
| CI/CD | GithubActions |
| バージョン管理ツール | GitHub・Git Flow |
| 開発環境 | Docker |
<br>

### 機能一覧
* 管理者ログイン機能
  * フォーム認証機能
* 都市/商品の登録・削除機能
  * csv取り込み機能
* 価格情報の初期追加機能
* 価格情報検索・一覧機能
  * インスタントサーチ機能
  * 遅延読み込みページネーション機能
  * 各種絞り込み機能
  * ソート機能
  * 知りたいボタン機能
  * 擬似的タイムスケジューラー機能
* 価格情報更新機能
  * モーダル機能
  * セッション機能
* フラッシュメッセージ機能
* エラーメッセージ機能
<br>

### 画面遷移図
Figma:https://www.figma.com/design/s7rvNSqj3MIS7hGgezBm5O/res-mkt-tre?t=NtS6argnCQ0J6aaC-0
<br>

## ER図
<img width="713" alt="image" src="https://i.gyazo.com/0e73e0572bd1155a310f3ae156b43733.png">
