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
w_sheet = s_sheets.worksheets[4]
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

def start(entered_data)
  while link_menu(menu, entered_data) != 0
  end
end

def menu
  puts "----- what's doing? -----"
  puts "0  exit"
  puts "1  display entered list"
  puts "2  add compony"
  puts "3  edit jobsheet"
  puts "4  sort menu"
  puts "------------------------------"
  gets.to_i
end

def link_menu(num, entered_data)
  case num
  when 0
    # 終了 exit
    return 0
  when 1
    list_display(entered_data)
  when 2
    new_application = add_company(entered_data)
    entered_data << new_application
  when 3
    list_display(entered_data)
    edit_sheet(entered_data, select_number + 12)
  when 4
    sort_data = entered_data[12, entered_data.length - 1]
    sort_data.map!.with_index { |data, i| change_phase_number(data, i) }
    sort_menu(sort_data)
    sort_data.map!.with_index { |data, i| change_number_phase(data, i) }
  end
end

def list_display(entered_data)
  puts "#########################"
  puts "----- list company  -----"
  puts "#########################"
  puts entered_data.map.with_index { |data, i|
    return start(entered_data) if i >= 12 && data[1] == ""
    list_i_name_phase(i - 12, data[1], data[4]) if i >= 12 && data[1] != ""
  }
end

def add_company(entered_data)
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
  current_phase = data[i][5]
  # phase_array = set_phase
  # phase_array.map.with_index{|phase, phase_i| data[i][5] = phase_i if phase == current_phase}
  case current_phase
  when "お見送り"
    data[i][5] = 7
  when "書類選考"
    data[i][5] = 6
  when "一次選考"
    data[i][5] = 5
  when "二次選考"
    data[i][5] = 4
  when "三次選考"
    data[i][5] = 3
  when "四次選考"
    data[i][5] = 2
  when "最終選考"
    data[i][5] = 1
  when "内定"
    data[i][5] = 0
  end
end

def change_number_phase(data, i)
  current_phase = data[i][5]
  # phase_array = set_phase
  # phase_array.map.with_index{|phase, phase_i| data[i][5] = phase if phase_i == phase}
  case phase
  when 7
    data[i][5] = "お見送り"
  when 6
    data[i][5] = "書類選考"
  when 5
    data[i][5] = "一次選考"
  when 4
    data[i][5] = "二次選考"
  when 3
    data[i][5] = "三次選考"
  when 2
    data[i][5] = "四次選考"
  when 1
    data[i][5] = "最終選考"
  when 0
    data[i][5] = "内定"
  end
end

def edit_sheet(entered_data, company_i)
  puts "------------------------------"
  puts entered_data[company_i].join(" | ")
  puts "what's company edit?"
  entered_data[8].map.with_index { |column, i| puts "#{i} : #{column}" }
  puts "------------------------------"
  num = select_number
  entered_data[company_i][num] = edit_company(entered_data, company_i, num)
end

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

def def(unimplemented)
  puts "------------------------------"
  puts "未実装です。"
  puts "------------------------------"
end

entered_data = set_data(w_sheet)
start(entered_data)

# entered_data.map.with_index { |data, i|
#   puts data.join("  ") if i == 8
#   puts data.join(" | ") if i >= 12 && data[1] != ""
# }
