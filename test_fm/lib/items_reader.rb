#:encoding: utf-8
require "net/http"
require "net/https"
require "csv"

$unique_keys = []

def read_items(settings)
  #puts "downloading items from: #{url}"
  url = settings["source_url"]
  required_fields = settings["required_fields"]||[]
  uri = URI.parse(url)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl     = true
  #http.read_timeout = 120 # socket timeout in seconds
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)

  begin
    body     = response.body.force_encoding("UTF-8") #for ruby 1.9 set force_encoding("UTF-8")
  rescue
    body     = response.body
  end
p body
  csv = CSV.parse(body)

  last_index = 0
  i = 0
  while i < csv.length
    if (csv[i][0] == nil)
      last_index = i
      break
    end
    i = i + 1
  end

  if last_index > 0
    csv = csv.slice(0, last_index)
  end

  csv.shift

  headers = csv.shift.map { |i| i.to_s.sub(/ .*$/, "") }
  string_data = csv.map do |row|
    n = 0
    row.map do |cell|
      key = headers[n]
      n += 1


      cell = cell.to_s.gsub(/“/,'"').gsub(/”/,'"').gsub('"', '\\\\\\\\\"').rstrip.lstrip
      raise "Need required field '#{key}' in item #{row[0]} (#{key}) template=#{settings["template_name"]}" if cell=="" && required_fields.include?(key) && row[1]
      if key == "key"
        raise "Item name not unique #{cell} template=#{settings["template_name"]}" if $unique_keys.include?(cell) && cell != ''
        raise "key have /[_0-9]/ in name #{cell} template=#{settings["template_name"]}" if cell =~ /_\d/
        $unique_keys.push(cell)
      end

      if key == "key" || key == "swf_name"
        cell.downcase!
        raise "key or swf_name have space #{cell} template=#{settings["template_name"]}" if cell =~ /[\s]/
        raise "key or swf_name have Cyrillic symbol in name #{cell} template=#{settings["template_name"]}" unless cell.scan(/[\p{Cyrillic}]/).empty?
        raise "key or swf_name have first - number symbol, but not a string symbol #{cell} template=#{settings["template_name"]}" if cell =~ /^(\d)/
      end
      raise "not purchase_coins_cost and purchase_gold_cost #{row[0]} template=#{settings["template_name"]}" if key == 'purchase_coins_cost' && !cell && !row[n]

      cell
    end
  end

  result = string_data.map { |row| Hash[*headers.zip(row).flatten] }
  puts "...OK"
  result
end

def item_value(item, name, default)
  if item[name] && item[name].length && item[name] != ""
    return item[name]
  end
  default
end