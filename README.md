# Readme

## 就活活動ファイル(GoogleDrive SpreadSheets)を操作するためのアプリです。

## 開発環境
- ruby 2.5.1
- GoogleAPIの取得（DriveとSpreadSheets）
- gem : google_drive 使用

## できること
- 企業情報の一覧表示
- 新規追加
　企業名　勤務先　どの媒体から　を入力することで、
　企業名　勤務先　媒体　書類選考　応募日（入力した日時）で新規作成
- 就活情報の編集（仮実装）
　選考フェーズのみ実装
- 並び替え
  昇順に並び替えを行う
  選考フェーズは　内定に近いほど上になるように設定

- 参考  <https://techblog.gmo-ap.jp/2018/12/04/ruby_google_sheets_drive/>