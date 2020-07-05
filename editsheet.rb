# encoding: utf-8
require "google_drive"
require "date"
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

## 入力済みデータ取得
def set_data(w_sheet)
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

def set_phase
  return ["内定", "最終選考", "四次選考", "三次選考", "二次選考", "一次選考", "書類選考", "お見送り"]
end

## ここから処理記述
def list_i_name_phase(i, name, phase)
  puts "------------------------------------------------------------"
  puts "#{i}:  #{name}  --  #{phase}"
end

def start(entered_data, i)
  return entered_data if i == 0
  puts "応募数 ： #{entered_data.length - 12}"
  link_menu(menu, entered_data)
end

def menu
  puts "----- what's doing? -----"
  puts "0  exit"
  puts "1  リスト表示（会社名：選考フェーズ）"
  puts "2  追加"
  puts "3  編集"
  puts "4  並び替え"
  puts "------------------------------"
  gets.to_i
end

def link_menu(num, entered_data)
  list_data = entered_data[12, entered_data.length - 1]
  case num
  when 0
    # 終了 exit
  when 1
    list_display(list_data)
  when 2
    new_application = add_company
    entered_data << new_application
  when 3
    list_display(list_data)
    edit_sheet(entered_data, select_number + 12)
  when 4
    sort_data = entered_data[12, entered_data.length - 1]
    sort_data.map!.with_index { |data, i| change_phase_number(data, i) }
    sort_data = data_sort(sort_data, select_sort_menu(entered_data[8]).to_i)
    sort_data.map!.with_index { |data, i| change_number_phase(data, i) }
    entered_data[12, entered_data.length - 1] = sort_data
  end
  start(entered_data, num)
end

def list_display(entered_data)
  puts "#########################"
  puts "----- list company  -----"
  puts "#########################"
  puts entered_data.map.with_index { |data, i|
    list_i_name_phase(i, data[1], data[4])
  }
end

def add_company
  puts "------------------------------"
  puts "Please input compony name."
  compony_name = gets.chomp
  puts "------------------------------"
  puts "compony name: #{compony_name}"
  puts "------------------------------"
  puts "Please input compony place."
  company_place = gets.chomp
  puts "------------------------------"
  puts "compony place: #{company_place}"
  puts "------------------------------"
  puts "Please input what's route."
  application_route = gets.chomp
  puts "------------------------------"
  puts "application route: #{application_route}"
  add_company_ary = ["", compony_name, company_place, application_route, "書類選考", Date.today, "", "", "", "", "", ""]
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

def select_number
  puts "------------------------------"
  puts "select input number"
  puts "------------------------------"
  gets.to_i
end

def sort_phase(entered_data)
  entered_data.sort! { |a, b| a[5] <=> b[5] }
end

def change_phase_number(data, i)
  phase_array = set_phase
  phase_array.map.with_index { |phase, phase_i| data[4] = phase_i if data[4] == phase }
  return data
end

def change_number_phase(data, i)
  phase_array = set_phase
  phase_array.map.with_index { |phase, phase_i| data[4] = phase if data[4] == phase_i }
  return data
end

def edit_sheet(entered_data, company_i)
  puts "------------------------------"
  puts entered_data[company_i].join(" ")
  puts "what's company edit?"
  entered_data[8].map.with_index { |column, i| puts "#{i} : #{column}" }
  puts "------------------------------"
  num = select_number
  entered_data[company_i][num] = edit_company(entered_data, company_i, num)
end

##　編集メニュー
def edit_company(entered_data, company_i, num)
  case num
  when 0
    # aspirations(entered_data)
  when 1
    # edit_name(entered_data, company_i)
  when 2
    # edit_place(entered_data, company_i)
  when 3
    # edit_application_route(entered_data, company_i)
  when 4
    return edit_phase(entered_data, company_i)
  when 5
    # edit_application_day(entered_data, company_i)
  when 6
    # edit_primary_selection_day(entered_data, company_i)
  when 7
    # edit_second_selection_day(entered_data, company_i)
  when 8
    # edit_final_selection_day(entered_data, company_i)
  when 9
    # edit_charm_point(entered_data, company_i)
  when 10
    # edit_concern_point(entered_data, company_i)
  when 11
    # edit_reflection_point(entered_data, company_i)
  when 12
    # edit_feedback(entered_data, company_i)
  when 13
    # edit_remarks(entered_data, company_i)
  end
  unimplemented
end

def edit_phase(entered_data, company_i)
  phase_array = set_phase
  puts "------------------------------"
  phase_array.map.with_index { |phase, i| puts "#{i} : #{phase}" }
  puts "------------------------------"
  puts "\n#{entered_data[company_i][1]} : #{entered_data[company_i][4]}"
  puts "どの選考フェーズか、番号で入力してください。"
  entered_data[company_i][4] = phase_array[gets.to_i]
end

def unimplemented
  puts "------------------------------"
  puts "未実装です。"
  puts "------------------------------"
end

def select_sort_menu(data)
  puts "------------------------------"
  data.map.with_index { |column, i| puts "#{i} : #{column}" }
  puts "------------------------------"
  puts "番号を入力してください。"
  gets.to_i
end

def data_sort(sort_data, sort_i)
  return sort_data.sort_by { |data| data[sort_i] }
end

def edit_w_sheet(w_sheet, result_data)
  result_data.map.with_index { |row_data, row_i|
    row_data.map.with_index { |column_data, column_i|
      w_sheet[row_i + 1, column_i + 1] = column_data
    }
  }
  w_sheet["E7"] = result_data.length - 12
  w_sheet["F7"] = count_phase(result_data, "一次選考") - 1
  w_sheet["G7"] = count_phase(result_data, "二次選考") - 1
  w_sheet["H7"] = count_phase(result_data, "最終選考")
end

def count_phase(result_data, phase)
  count = 0
  result_data.map { |data| count += 1 if data.include?(phase) }
  return count
end

entered_data = set_data(w_sheet)
result_data = start(entered_data, 1)
edit_w_sheet(w_sheet, result_data)
w_sheet.save
