# encoding: utf-8
require "date"
require "nkf"
require "pry"

class Edit
  def initialize(w_sheet)
    @w_sheet = w_sheet
  end

  def edit
    result_w_sheet(start(set_data, 1))
    @w_sheet
  end

  private

  ########## メニュー  #############################################
  def start(table_data, i)
    return table_data if i == 0
    puts "-- 応募数 ： #{table_data.length - 12} --"
    link_menu(table_data, menu)
  end

  def menu
    menu_array = set_menu
    puts "-----     what's doing     -----"
    input_number_and_show_array(menu_array)
    return select_number(menu_array)
  end

  def link_menu(table_data, num)
    case num
    when 0
      ## 終了 exit ##
    when 1
      show_method(table_data)
    when 2
      new_method(table_data)
    when 3
      edit_method(table_data)
    when 4
      sort_method(table_data)
    end
    start(table_data, num)
  end

  ## 一覧表示＋詳細表示メニュー
  def show_method(table_data)
    display_company_list(table_data)
    view_the_details(table_data) if confirm_view_the_details
  end

  ## 新規登録メニュー
  def new_method(table_data)
    company_name = input_type_in_column("Please input compony name.") ##会社名入力
    puts "-----     compony name : #{company_name}     -----"
    company_place = input_type_in_column("Please input compony place.") ##勤務地入力
    puts "-----     compony place : #{company_place}     -----"
    application_route = set_application_route
    route_i = select_application_route(application_route)  ## 応募媒体入力
    puts "-----     application route : #{application_route[route_i]}     -----"
    ## 応募情報を追加
    table_data.push(["", company_name, company_place, application_route[route_i], "書類選考", Date.today, "", "", "", "", "", ""])
    table_data
  end

  ## 編集メニュー
  def edit_method(table_data)
    display_company_list(table_data)
    edit_sheet(table_data, select_number(table_data[12..-1]) + 12)
  end

  ## 並び替えメニュー
  def sort_method(table_data)
    sort_data = convert_sort_data(table_data[12..-1])                      ## 選考段階を数値に変換
    sort_data = data_sort(sort_data, select_sort_menu(table_data[8]).to_i) ## 並び替え
    sort_data = resconstitute_sort_data(sort_data)                          ## 選考段階を戻す
    table_data[12..-1] = sort_data                                         ## 元データに保存
  end

  def set_data
    table_data = []
    row_i = 1
    while true
      return table_data if row_i > 13 && @w_sheet[row_i, 2] == ""
      line = []
      for column_i in 1..14
        line.push(@w_sheet[row_i, column_i])
      end
      table_data.push(line)
      row_i += 1
    end
  end

  def set_table_data(row)
    line = []
    (1..14).map { |column| line.push(@w_sheet[row, column]) }
    return line
  end

  def result_w_sheet(table_data)
    table_data.map.with_index(1) { |row, row_i|
      row.map.with_index(1) { |column, column_i|
        @w_sheet[row_i, column_i] = column
      }
    }
    @w_sheet["F7"] = "=COUNTA(B13:B999)"
    @w_sheet["G7"] = "=COUNTA(G13:G999)"
    @w_sheet["H7"] = "=COUNTA(H13:H999)"
    @w_sheet["I7"] = "=COUNTA(I13:I999)"
  end

  def set_phase
    return ["内定", "最終選考", "四次選考", "三次選考", "二次選考", "一次選考", "書類選考", "お見送り"]
  end

  def set_application_route
    return ["TECH CAMP経由", "企業ホームページ経由", "Wantedly経由", "リクナビNEXT経由", "リクルートエージェント経由", "Green経由", "paiza経由"]
  end

  def set_menu
    return ["終了", "リスト表示（会社名：選考フェーズ）", "新規追加", "編集", "並び替え"]
  end

  ## 月の配列作成
  def set_month
    [*1..12]
  end

  ## 日の配列作成（1,3,5,7,8,10,12 : 31, 4,6,9,11 : 30, 2 : 28 or 29）
  def set_day
    today_array = Date.today.strftime.split("-")
    case today_array[1] ## 月
    when 1, 3, 5, 7, 8, 10, 12
      max = 31
    when 4, 6, 9, 11
      max = 30
    when 2
      max = 28 if today_array[0] % 4 != 0
      max = 29 if today_array[0] % 4 == 0
    end
    [*1..max]
  end

  ##########  共通  ############
  ##  表示するもの
  def puts_fence_string(string)
    puts "----------      #{string}      ----------"
  end

  ##  番号：エレメント (一覧表示)
  def input_number_and_show_array(array)
    puts "------------------------------"
    array.map.with_index { |element, i| puts "#{i} : #{element}" }
    puts "------------------------------"
  end

  ##  配列 一列表示
  def puts_array_join(array)
    puts array.join(" | ")
  end

  ##  番号選択＋確認
  def select_number(array)
    puts "-----     select input number     -----"
    return check_input_index(array)
  end

  def gets_hankaku_to_i
    gets.tr("Ａ-Ｚ０-９", "A-Z0-9").to_i
  end

  def check_input_index(array)
    max_i = array.length - 1
    number = gets_hankaku_to_i
    return number if number <= max_i && number >= 0
    puts "入力は、#{0} から #{max_i} の範囲で入力してください。"
    check_input_index(array)
  end

  def yes_or_no?
    puts "------------------------------"
    puts "1 : YES"
    puts "2 : NO"
    puts "------------------------------"
    input = gets_hankaku_to_i
    return true if input == 1
    false
  end

  def unimplemented
    puts "-----     未実装です。     -----"
  end

  ##############  メニュー1  #############################################
  #####  一覧表示＋詳細表示  #####
  def display_company_list(table_data)
    puts_fence_string("company list")
    table_data[12..-1].map.with_index { |data, i|
      puts "---------------------------------------------"
      puts "#{i}:  #{data[1]} | #{data[4]}"
    }
  end

  def confirm_view_the_details
    puts_fence_string("詳細を見る？")
    return yes_or_no?
  end

  def view_the_details(table_data)
    puts_fence_string("what's preview?")
    select_data = table_data[select_number(table_data[12..-1]) + 12][0, 9]
    puts_array_join(table_data[8][0, 9])
    puts_array_join(select_data)
  end

  ##############  メニュー2  #############################################
  #####  新規登録 #####

  def confirmation?(input)
    puts "-----  #{input}  -----"
    puts "この内容で良いですか？"
    return yes_or_no?
  end

  def input_type_in_column(input_column) ##
    puts "-----  #{input_column}  -----"
    result = gets.chomp
    return result if confirmation?(result)
    input_type_in_column(input_column)
  end

  def select_application_route(application_route) ## 応募経路選択
    input_number_and_show_array(application_route)
    puts "-----  どの媒体からか、番号で入力してください。  -----"
    return select_number(application_route)
  end

  ##############  メニュー3  #############################################
  #####  表データ編集  #####

  def edit_sheet(table_data, company_i)
    puts "------------------------------"
    puts_array_join(table_data[8])
    puts_array_join(table_data[company_i])
    puts "     what's company edit?     "
    input_number_and_show_array(table_data[8])
    column_i = select_number(table_data[8])
    table_data = edit_menu(table_data, company_i, column_i)
  end

  ##  編集メニュー
  def edit_menu(table_data, company_i, column_i)
    case column_i
    when 0
      # edit_aspirations
      unimplemented
    when 3
      edit_application_route(table_data, company_i, column_i)
    when 4
      edit_phase(table_data, company_i)
    when 5, 6, 7, 8
      edit_phase_schedule(table_data, company_i, column_i)
    when 1, 2, 9, 10, 11, 12, 13
      edit_company_other_data(table_data, company_i, column_i)
    end
  end

  ## 志望順位編集
  # def edit_aspirations(table_data)
  #     table_data = []
  #       table_data = table_data[12..-1]
  #
  #   table_data.map.with_index { |company, company_i|
  #     puts "#{company_i}, 志望順位 : #{company[0]}, 企業名 : #{company[1]}"
  #   }
  #   table_data = reset_aspirations(table_data)
  #   input_aspirations(table_data)
  # end

  # def input_aspirations(table_data)

  # end
  #   def reset_aspirations(table_data)
  #     for i in 0..table_data.length
  #       table_data[i][0] = ""
  #     end
  #     table_data
  #   end

  ## 応募経路編集
  def edit_application_route(table_data, company_i, column_i)
    application_route = set_application_route
    puts "現在の#{table_data[8][column_i]} : #{application_route[column_i]}"
    puts route = application_route[input_number_and_show_array(application_route)]
    edit_application_route(table_data, column_i) unless yes_or_no?
    table_data[company_i][column_i] = route
    table_data
  end

  ## 選考フェーズ編集
  def edit_phase(table_data, company_i)
    puts "#{table_data[company_i][1]} : #{table_data[company_i][4]}"
    table_data[company_i][4] = select_phase
    table_data
  end

  def select_phase
    phase_array = set_phase
    input_number_and_show_array(phase_array)
    phase_i = select_number(phase_array)
    confirmation?(phase_array[phase_i]) ? phase_array[phase_i] : select_phase
  end

  ## 選考日程編集
  def edit_phase_schedule(company_i, column_i)
    puts "現在の#{table_data[8][column_i]} : #{table_data[company_i][column_i]}"
    table_data[company_i][4] = table_data[8][column_i].delete("日程")
    table_data[company_i][column_i] = input_schedule
    table_data
  end

  def input_schedule
    month_array = set_month
    day_array = set_day
    input_month = input_num("何月？", month_array).to_s
    input_day = input_num("何日？", day_array).to_s
    puts result = "#{input_month}/#{input_day}"
    return result if yes_or_no?
    input_schedule
  end

  def input_num(string, array)
    puts "-----     #{string}     -----"
    return check_shcedule(array)
  end

  def check_shcedule(array)
    max_i = array.length
    number = gets.tr("Ａ-Ｚ０-９", "A-Z0-9").to_i
    return number if number <= max_i && number >= 1
    puts "入力は、#{1} から #{max_i} の範囲で入力してください。"
    check_shcedule(array)
  end

  ## その他の情報の編集
  def edit_company_other_data(table_data, company_i, column_i)
    column_name = table_data[8][column_i]
    temporary_data = table_data[company_i][column_i]
    puts "現在の#{column_name} ： #{temporary_data}"
    case column_i
    when 1, 2
      table_data[company_i][column_i] = input_type_in_column(column_name)
    else
      table_data[company_i][column_i] = "#{temporary_data}\n" + "#{input_type_in_column(column_name)}"
    end
    table_data
  end

  ##############  メニュー4  #############################################
  ## 並び替え
  def select_sort_menu(data)
    input_number_and_show_array(data)
    select_number(data)
  end

  def data_sort(sort_data, sort_i)
    return sort_data.sort_by { |data| data[sort_i] }
  end

  ## 並び替え用配列変更
  def convert_sort_data(table_data)
    table_data.map! { |data| change_phase_string_to_number(data) }
    # table_data.map! { |data| data[0] = 999 if data[0] == "" }
  end

  def change_phase_string_to_number(data)
    phase_array = set_phase
    phase_array.map.with_index { |phase, phase_i| data[4] = phase_i if data[4] == phase }
    return data
  end

  ## 並び替え用配列元に戻す
  def resconstitute_sort_data(table_data)
    table_data.map! { |data| change_phase_number_to_string(data) }
    # table_data.map! { |data| data[0] = "" if data[0] == 999 }
  end

  def change_phase_number_to_string(data)
    phase_array = set_phase
    phase_array.map.with_index { |phase, phase_i| data[4] = phase if data[4] == phase_i }
    return data
  end
end
