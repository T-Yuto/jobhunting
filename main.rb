# encoding: utf-8
require "google_drive"
require "./edit"
#
session = GoogleDrive::Session.from_config("config.json")
##スプレッドシート取得
s_sheets = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1lmDJb49PxtkW-YHwjZpcovNpHsPybV9X8dhbgt8qnyM/edit#gid=1035003115")
##ワークシート取得
w_sheet = s_sheets.worksheets[0]
# w_sheet[行, 列]で指定！！[row, column]  行: 番号、列: 英字
data = Edit.new(w_sheet)
w_sheet = data.edit
w_sheet.save
