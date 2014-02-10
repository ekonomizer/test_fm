namespace :fm do
  task :yaml_to_json, [:db] => :environment do |t, args|
    require 'json'
    require 'yaml'
    require 'tfp'

    databases = args[:db].split(',')
    databases.each do |table_name|
      yml = Tfp.load("././test/fixtures/#{table_name}.yml")
      items = YAML::load(yml)

      counter = 1
      items.each do |item|
        json = JSON.dump(item[1])

        File.open("#{Rails.root}/public/json_items/#{table_name}/#{item[1]['id']}.json", 'w') do |file|
          file.write json
        end
        counter += 1
      end
    end
  end
end