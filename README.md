# Readme

## 就活活動ファイル(GoogleDrive SpreadSheets)を操作するためのアプリです。

## 開発環境
- ruby 2.5.1
- GoogleAPIの取得（DriveとSpreadSheets）
- gem : google_drive 使用

## できること
- 企業情報の一覧表示
<img alt="list" src="https://raw.githubusercontent.com/T-Yuto/jobhunting/readme_Image/image/一覧表示.png" width= "500px">
- 新規追加
　企業名　勤務先　どの媒体から　を入力することで、
　企業名　勤務先　媒体　書類選考　応募日（入力した日時）で新規作成
<img alt="add" src="https://raw.githubusercontent.com/T-Yuto/jobhunting/readme_Image/image/新規追加.gif" width= "500px">
- 就活情報の編集（仮実装）
　選考フェーズのみ実装
<img alt="edit" src="https://raw.githubusercontent.com/T-Yuto/jobhunting/readme_Image/image/選考フェーズ編集.gif" width= "500px">
- 並び替え
  昇順に並び替えを行う
  選考フェーズは　内定に近いほど上になるように設定
  <img alt="sort" src="https://raw.githubusercontent.com/T-Yuto/jobhunting/readme_Image/image/ソート機能.gif" width= "500px">

- 参考  <https://techblog.gmo-ap.jp/2018/12/04/ruby_google_sheets_drive/>