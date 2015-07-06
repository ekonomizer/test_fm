#namespace :db do
# desc "Load exported fixtures (in fm_ymls/exported_fixtures) into the current environment's database"
# task :load_from_yml => :environment do
#   require 'active_record/fixtures'
#   ActiveRecord::Base.establish_connection(Rails.env.to_sym)
#   Dir.glob(File.join(Rails.root, 'fm_ymls', '*.{yml,csv}')).each do |fixture_file|
#     Fixtures.create_fixtures('fm_ymls', File.basename(fixture_file, '.*'))
#   end
# end
#end

# extract_fixtures.rake
#  by Paul Schreiber <paulschreiber at gmail.com>
#  15 June 2010
#
#  I got this from Peter Gulezian <http://metoca.net/>
#  Looks like another version is here
#  <http: //redmine.rubyforge.org/svn/trunk/lib/tasks/extract_fixtures.rake>
#
# This is the inverse of the built-in rake db:fixtures:load
# Usage: rake db:fixtures:extract
# rake db:fixtures:extract FIXTURES=foo
# rake db:fixtures:extract FIXTURES=foo,bar
# rake db:fixtures:load FIXTURES=foo,bar





namespace :db do

  namespace :fixtures do
    desc 'Create YAML test fixtures from data in an existing database.
    Defaults to development database. Set RAILS_ENV to override.'
    task :extract => :environment do
      sql = "SELECT * FROM %s"
      skip_tables = ["schema_migrations"]
      ActiveRecord::Base.establish_connection
      if ENV["FIXTURES"]
        tables = ENV["FIXTURES"].split(",")
      else
        tables = (ActiveRecord::Base.connection.tables - skip_tables)
      end
      tables.each do |table_name|
        p table_name
        i = "00000000"
        File.open("#{Rails.root}/test/fixtures/#{table_name}.yml", 'w') do |file|
          data = ActiveRecord::Base.connection.select_all(sql % table_name)
          file.write data.inject({}) { |hash, record|
                       hash["#{table_name}_#{i.succ!}"] = record
                       hash
                     }.to_yaml
        end
      end
    end

    desc 'Import to db from fixtures, and create json'
    task :load_and_create_json => :environment do
      p ARGV
      p ARGV[1]
      sh "rake db:fixtures:load FIXTURES=#{ARGV[1]}"
      Rake::Task["fm:yaml_to_json"].invoke(ARGV[1])
    end
  end


  desc 'Fill all tables in DB, need call first start'
  task :load_all_fixtures do

    args = "cities,countries,clubs,leagues,universes,player_first_names,player_last_names"
    p 'LOAD FIXTURES:'
    p args

    sh "rake db:fixtures:load FIXTURES=#{args}"
    Rake::Task["fm:yaml_to_json"].invoke(args)
  end
end






