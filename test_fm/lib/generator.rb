#!/usr/bin/env ruby
#require File.join(File.dirname(__FILE__), '../config/environment')
require 'yaml'
require File.join(File.dirname(__FILE__), "items_reader")
require File.join(File.dirname(__FILE__), "items_generator")
#require File.join(File.dirname(__FILE__), "item_post_process_policy")
require File.join(File.dirname(__FILE__), "tfp")

def full_name(file_name)
  File.join(File.dirname(__FILE__), file_name)
end

#puts "reading shared_config..."
#@shared_config_item = YAML.load(Tfp.load(File.join(File.dirname(__FILE__), ["..", "config", "market", "market_shared_config.yml.common"])))
#puts "shared_config readed"
puts "==================================================="

items_settings = [
# лиги
    {
        "source_url" => "https://docs.google.com/spreadsheet/pub?key=0Ar-vWk5fEacUdGR4U1pzZ2xGZ0Fnbkk4XzVDRTA3aXc&single=true&gid=1&output=csv",
        "output_file" => "../test/fixtures/leagues.yml",
        #"rb_output_file" => "../app/models_market/stage_items/stocks.rb",
        "template_name" => "leagues",
        "required_fields" => ['id','name_ru','name_en']
    },
# страны
    {
        "source_url" => "https://docs.google.com/spreadsheet/pub?key=0Ar-vWk5fEacUdGR4U1pzZ2xGZ0Fnbkk4XzVDRTA3aXc&single=true&gid=0&output=csv",
        "output_file" => "../test/fixtures/countries.yml",
        "template_name" => "countries",
        "required_fields" => ['id','name_ru','name_en','league_id']
    },
# города
    {
        "source_url" => "https://docs.google.com/spreadsheet/pub?key=0Ar-vWk5fEacUdGR4U1pzZ2xGZ0Fnbkk4XzVDRTA3aXc&single=true&gid=2&output=csv",
        "output_file" => "../test/fixtures/cities.yml",
        "template_name" => "cities",
        "required_fields" => ['id','name_ru','name_en']
    },
# клубы
    {
        "source_url" => "https://docs.google.com/spreadsheet/pub?key=0Ar-vWk5fEacUdGR4U1pzZ2xGZ0Fnbkk4XzVDRTA3aXc&single=true&gid=3&output=csv",
        "output_file" => "../test/fixtures/clubs.yml",
        "template_name" => "clubs",
        "required_fields" => ['id','name_ru','name_en']
    }
]


def set_param(data, k, v, default = nil)
  res = v
  if !default.nil? && v && v.length && v != ""
    res = default
  end
  data.push([k,res])
end

def convert_it(v)
  return "\"#{v}\"" if v.class == String
  return v.map{|s| "\n    - #{convert_it(s)}"}.join if v.class == Array
  return v
end

def generate_params data
  s = []
  data.each do |k,v|
    s << "#{k.to_s}: #{convert_it(v)}"
  end
  s.join("\n  ")
end


if ARGV.empty?
  puts "***** Generating All *****"
  $unique_keys = []
end

items = {}
read_cache = {}
puts "***** reading items *****"

items_settings.each do |settings|
  if ARGV.empty? || ARGV.include?(settings["template_name"])
    puts "#{settings["template_name"]} =>> downloading items from: #{settings["source_url"]}"
    #threads << Thread.new(settings) { |it|
    it = settings
    items[it["template_name"]] = {}
    items[it["template_name"]]["settings"] = it
    read_cache[it["source_url"]] ||= read_items(it)
    items[it["template_name"]]["items"] = read_cache[it["source_url"]]
  end
end
#threads.each { |thread| thread.join }
puts "******* all items readed *******"
puts "******* generate items *******"
all_items = {}
items.each do |k, v|
  if ARGV.empty? || ARGV.include?(k)
    next if k == "buildsite"

    @counter = "00000000"
    puts "======================================================="
    puts "generate items metadata from template: #{k}"
    result, rb_result = generate_items_list(v["items"], k, v["settings"]["server_classes_folder"])

    v["items"].each do |item|
      all_items[item['key']] = item['description'] if item['shoppable'].to_i == 0
    end

    puts "write items metadata #{v["settings"]["output_file"]}"
    write_result(v["settings"]["output_file"], result)
    puts "write ruby classes into #{v["settings"]["rb_output_file"]}"
    write_result(v["settings"]["rb_output_file"], rb_result)
  end
end