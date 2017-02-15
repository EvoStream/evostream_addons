#!/usr/bin/ruby -w
# -*- coding: utf-8 -*-
$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/../lib"

# convert performance test data from .csv to .xlsx with charts

require "csv"
require 'axlsx'

def replace_header(header)
  header.gsub!("%", "")
  case header
    when /w1/
      header.gsub!("w1", "EWS")
    when /r1/
      header.gsub!("r1", "RUBY")
    when /cpusum/
      header.gsub!("cpusum", "cpuSUM")
    when /all/
      header.gsub!("all", "ALL")
    when '_'
      header = 'note'
  end
  puts header #-#
  return header
end

def add_series_to_chart(sheet, chart, column, lines, color)
  cell_header = Axlsx::cell_r(column, 0)
  cell_start = Axlsx::cell_r(column, 1)
  cell_end = Axlsx::cell_r(column, lines - 1)
  chart.add_series :xData => sheet["A2:A#{lines - 1}"], :yData => sheet["#{cell_start}:#{cell_end}"],
      :title => sheet["#{cell_header}"], :color => color
end

def get_column_max(column, lines)
  cell_start = Axlsx::cell_r(column, 1)
  cell_end = Axlsx::cell_r(column, lines - 1)
  return "=max(#{cell_start}:#{cell_end})"
end

begin

  # all csv files
  csv_files = Dir.glob("*.csv")
  csv_files.each do |filename|

    # open csv file
    csv_file_path = File.join(File.dirname(__FILE__), filename)
    print "#{csv_file_path}: "

    # open sheet
    package = Axlsx::Package.new
    wb = package.workbook
    wb.add_worksheet(:name => "performance") do |sheet|

      # read csv row, add sheet row
      headers = []
      items = []
      lines = 0
      CSV.foreach(csv_file_path, :headers => true, :header_converters => :symbol, :converters => :numeric) do |row|
        if headers.size == 0
          headers = row.headers
          headers.size.times do |i|
            header = headers[i].to_s.downcase
            header = replace_header(header)
            headers[i] = header.to_sym
          end
          sheet.add_row headers
        else
          items = row.collect { |k, v| v }
          sheet.add_row items
        end
        lines += 1
        print "#{lines} "
      end
      puts

      # map header to column
      column = {}
      headers.size.times do |i|
        column[headers[i]] = i
      end

      # add row with max values per column
      if headers.size != 0
        column_max = []
        headers.size.times do |i|
          if i == 0
            column_max[i] = "MAX"
          else
            column_max[i] = get_column_max(i, lines)
          end
        end
        sheet.add_row column_max
      end

      # generate stream count chart
      sheet.add_chart(Axlsx::ScatterChart, :title => "STREAM COUNT") do |chart|
        chart.start_at 0, lines + 1
        chart.end_at 20, lines + 16
        add_series_to_chart(sheet, chart, column[:count], lines, "FF0000")
        chart.x_val_axis.cross_axis.title = 'count'
        chart.x_val_axis.title = 'seconds'
      end

      # generate cpu usage chart
      sheet.add_chart(Axlsx::ScatterChart, :title => "CPU USAGE") do |chart|
        chart.start_at 0, lines + 17
        chart.end_at 20, lines + 32
        add_series_to_chart(sheet, chart, column[:cpuALL], lines, "808080")
        add_series_to_chart(sheet, chart, column[:cpuSUM], lines, "0000FF")
        add_series_to_chart(sheet, chart, column[:cpuRUBY], lines, "00FF00")
        add_series_to_chart(sheet, chart, column[:cpuEWS], lines, "FF0000")
        column[:cpue1].upto(column[:cpuEWS] - 1) do |col|
          add_series_to_chart(sheet, chart, col, lines, "808000")
        end
        chart.x_val_axis.cross_axis.title = 'CPU %'
        chart.x_val_axis.title = 'seconds'
      end

      # generate mem usage chart
      sheet.add_chart(Axlsx::ScatterChart, :title => "MEM USAGE") do |chart|
        chart.start_at 0, lines + 33
        chart.end_at 20, lines + 48
        add_series_to_chart(sheet, chart, column[:memRUBY], lines, "00FF00")
        add_series_to_chart(sheet, chart, column[:memEWS], lines, "FF0000")
        column[:meme1].upto(column[:memEWS] - 1) do |col|
          add_series_to_chart(sheet, chart, col, lines, "808000")
        end
        chart.x_val_axis.cross_axis.title = 'MEM %'
        chart.x_val_axis.title = 'seconds'
      end

      # generate bandwidth chart
      sheet.add_chart(Axlsx::ScatterChart, :title => "BANDWIDTH") do |chart|
        chart.start_at 0, lines + 49
        chart.end_at 20, lines + 64
        add_series_to_chart(sheet, chart, column[:sum_kbps], lines, "FF0000")
        add_series_to_chart(sheet, chart, column[:tx_kbps], lines, "0000FF")
        add_series_to_chart(sheet, chart, column[:rx_kbps], lines, "00FF00")
        chart.x_val_axis.cross_axis.title = 'kbps'
        chart.x_val_axis.title = 'seconds'
      end

    end

    # write xls file
    filename.gsub!(".csv", ".xlsx")
    package.serialize(filename)

  end
end
