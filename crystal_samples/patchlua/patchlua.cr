#!/usr/bin/crystal
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# Patch EMS configuration file - update a parameter, insert text from a file, or clean.
# Note: Spaces and blank lines are removed, indentations are normalized.
#
# Usages:
# 1. To update a parameter in the EMS configuration file:
#    ./patchlua <ems_configuration_file> update <paramenter_name> <new_parameter_value>
# 2. To insert text from a file into the EMS configuration file:
#    ./patchlua <ems_configuration_file> insert <file_with_text_to_insert> <param_level_1> .. <param_level_n>
# 3. To clean the EMS configuration file:
#    ./patchlua <ems_configuration_file>
#
# The output file name is the name of the input file with extension changed to '.txt'.
#
 
FILENAME = "config.lua"
INDENT = "\t"
SHOW_COMMENTS = true
ENABLE_LOG = false

def patch_clean(in_filename, out_filename, key="", value="")
  in_file = File.open(in_filename, "r")
  out_file = File.open(out_filename, "w")
  comment_block = 0
  indent = 0
  in_file.each_line do |text|

    text = text.chomp
    comment_block += 1 if text =~ /--\[[=]*\[/
    comment_text = ""
    if text =~ /--/
      if comment_block == 0
        text_split = text.split("--")
        text = text_split[0]
        (text_split.size - 1).times do |i|
          comment_text += "--" + text_split[i + 1] if !text_split[i + 1].nil?
        end
        comment_text = comment_text.gsub(/\t/, INDENT)
      end
    else
      comment_text = ""
    end
    if comment_block > 0
      comment_block -= 1 if text =~ /\][=]*\]--/
      text = text.gsub(/\t/, INDENT)
      out_file.puts text if SHOW_COMMENTS
      next
    end

    text = text.gsub(/[\t ]+/, "")
    text = text.gsub(/[\t ]*\{/, "{").gsub(/\{[\t ]*/, "{").gsub(/[\t ]*\}/, "}")
    text = text.gsub(/,[\t ]*/, ",")
    if text =~ /[=].*,/
      puts "-- #{text}" if ENABLE_LOG
      text_split = text.split(/[=,]/)
      puts text_split.to_s if ENABLE_LOG
      orig_value = text_split[1]
      if text_split[0].downcase == key.downcase
        if (orig_value[0] == '"')
          text_split[1] = "\"" + value + "\""
        else
          text_split[1] = value
        end
        text = text_split[0] + "=" + text_split[1] + "," + text_split[2]
        puts "=> #{text}" if ENABLE_LOG
      end
    end

    next if (text + comment_text).size == 0

    indent -= 1 if text =~ /}/ && !(text =~ /{.*}/)
    indent.times { text = INDENT + text }
    indent += 1 if text =~ /{/ && !(text =~ /{.*}/)

    text += comment_text if SHOW_COMMENTS
    out_file.puts text
  end
  in_file.close
  out_file.close
end

def patch_update(in_filename, out_filename, key, value)
  puts "patch update: #{in_filename} #{out_filename} #{key} #{value}" if ENABLE_LOG
  patch_clean(in_filename, out_filename, key, value)
end

def patch_insert(in_filename, out_filename, insert_filename, *parameters)
  puts "patch insert: #{in_filename} #{out_filename} #{insert_filename} #{parameters.to_s}" if ENABLE_LOG
  patch_clean(in_filename, out_filename)
end

def help(command)
  puts
  case command.downcase
  when ""
    puts "Syntax for clean:"
    puts "  ./patchlua config.lua"
  when "insert"
    puts "Syntax for insert:"
    puts "  ./patchlua webconfig.lua insert apiProxy.lua configuration applications rootDirectory"
  when "update"
    puts "Syntax for update:"
    puts "  ./patchlua apiproxy.lua update userName evostream"
  else
    puts "invalid command"
  end
  puts
end

def help
  help("")
  help("insert")
  help("update")
end

if ARGV.size == 0
  puts "missing filename"
  help
  exit
end

command = ""
in_filename = ""
out_filename = ""
parameters = [] of String
total_items = ARGV.size
last_item = ARGV.size - 1
total_items.times do |item|
  case item
  when 0
    in_filename = ARGV[item]
    name = in_filename.split "."
    in_filename = name[0] + ".lua" if name.size < 2
    if !File.exists? in_filename
      puts "missing file: #{in_filename}"
      help
      exit
    end
    out_filename = name[0] + ".txt" 
    puts "#{in_filename} => #{out_filename}" if ENABLE_LOG
  when 1
    command = ARGV[item].downcase
  else
    parameters << ARGV[item]
    if item == last_item
      case command
      when "insert"
        puts command if ENABLE_LOG
        if total_items < 6
          puts "insufficient parameters for insert"
          help(command)
          exit
        else
          insert_filename = ARGV[2]
          items_left = last_item - 2
          items_left.times { |i| parameters << ARGV[i + 3] }
          patch_insert(in_filename, out_filename, insert_filename, parameters)
        end
      when "update"
        puts command if ENABLE_LOG
        if total_items < 4
          puts "insufficient parameters for update"
          help(command)
          exit
        else
          key = ARGV[2]
          value = ARGV[3]
          patch_update(in_filename, out_filename, key, value)
        end          
      when ""
        puts "clean" if ENABLE_LOG
        patch_clean(in_filename, out_filename)
      else
        puts "invalid command"
      end
    end
  end
end

