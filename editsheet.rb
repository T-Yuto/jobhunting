require "google_drive"
# Creates a session. This will prompt the credential via command line for the
# first time and save it to config.json file for later usages.
# See this document to learn how to create config.json:
# https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md

session = GoogleDrive::Session.from_config("config.json")
# https://docs.google.com/spreadsheets/d/1lmDJb49PxtkW-YHwjZpcovNpHsPybV9X8dhbgt8qnyM/edit#gid=1035003115
##スプレッドシート取得
s_sheets = session.spreadsheet_by_url("https://docs.google.com/spreadsheets/d/1lmDJb49PxtkW-YHwjZpcovNpHsPybV9X8dhbgt8qnyM/edit#gid=1035003115")
##ワークシート取得
w_sheet = s_sheets.worksheets[0]
# w_sheet[行, 列]で指定！！[row, column]  行: 番号、列: 英字
##########

def set_data(w_sheet)
  ## 入力済みデータ取得
  row = 1
  entered_data = []
  while true
    return entered_data if row > 13 && w_sheet[row, 2] == ""
    entered_data.push(set_entered_data(row, w_sheet))
    row += 1
  end
end

def set_entered_data(row, w_sheet)
  line = []
  (1..14).map { |column| line.push(w_sheet[row, column]) }
  return line
end

def list_i_name(i, name) 2
  puts "------------------------------"
  puts "#{i}  #{name}" end

# def sort_phase(data)
#   phase = data[5]
#   case phase
#   when "お見送り"
#   when "書類選考"
#   when "一次選考"
#   when "二次選考"
#   when "三次選考"
#   when "四次選考"
#   when "最終選考"
#   when "内定"
# end

def start(entered_data)
  i = menu
  link_menu(i, entered_data)
end

def menu
  puts "----- what's doing? -----"
  puts "0  display entered list"
  puts "1  add compony"
  puts "2  edit jobsheet"
  puts "3  sort menu"
  puts "------------------------------"
  gets.to_i
end

def link_menu(num, entered_data)
  case num
  when 0
    list_display(entered_data)
  when 1
    add_compony(entered_data)
  when 2
    edit_sheet(entered_data)
  when 3
    sort_menu(entered_data)
  end
end

def list_display(entered_data)
  puts "----- list company -----"
  puts entered_data.map.with_index { |data, i| list_i_name(i - 12, data[1]) if i >= 12 }
  start(entered_data)
end

def add_company
  puts "------------------------------"
  puts "Please input compony name."
  compony_name = gets.chomp
  puts "------------------------------"
  puts "compony name: #{compony_name}"
end

def select_preview(entered_data)
  puts "------------------------------"
  puts "what's preview?"
  puts "------------------------------"
  row_input = gets.to_i
  puts "name: #{entered_data[row_input + 12][1]}, phase: #{entered_data[row_input + 12][4]}"
end

##選考フェーズ表示 会社名  選考フェーズ
def phase_puts(entered_data)
  entered_data.map.with_index { |data, i|
    puts "------------------------------"
    puts "#{i}  #{data[1]}"
    puts "#{data[4]}"
  }
end

entered_data = set_data(w_sheet)
start(entered_data)
