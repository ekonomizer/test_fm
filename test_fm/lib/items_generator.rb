#:encoding: utf-8
require "erb"

def generate_item(item, template_name, ruby_classes_folder, class_suffix = "")

  template = File.open(full_name("../generator/#{template_name}.yml.erb")).read
  result   = ERB.new(template).result(binding)

  ruby_template_file = full_name("../generator/#{template_name}.rb.erb")
  ret = [result]

  if File.exists?(ruby_template_file)
    class_tmp    = File.open(ruby_template_file).read
    class_name   = item["key"].split("_").map { |word| word.capitalize }.join
    class_result = ERB.new(class_tmp).result(binding)
    ret.push(class_result)

    #File.new(full_name("#{ruby_classes_folder}/#{item["key"]}#{class_suffix}_item.rb"), File::CREAT|File::TRUNC|File::RDWR, 0644).write(class_result)
  end

  ret
end

def generate_items_list(array_of_hashes, template_name, classes_folder, post_process_policy = nil)
  result = ""
  rb_result = ""

  array_of_hashes = array_of_hashes.select { |i| i["key"] != "" && i["id"] != "" }.sort { |a, b| a["id"].to_i - b["id"].to_i }

  array_of_hashes.each do |item|
    template = (item["template"].nil? || item["template"] == "") ? template_name : item["template"].to_s
    strs = generate_item(item, template, classes_folder)
    result = result.concat(strs.first)
    rb_result = rb_result.concat(strs[1]) if strs.length > 1

    if post_process_policy != nil
      r = post_process_policy.process_item item
      if r != nil
        result += r[0]
        rb_result += r[1] if r.length > 1
      end
    end
  end
  [result, rb_result]
end

def write_result(file_name, result)
  return if result.nil? or result==""
  File.new(full_name(file_name), File::CREAT|File::TRUNC|File::RDWR, 0644).write(result)
end