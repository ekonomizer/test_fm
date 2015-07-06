namespace :db do
  desc 'Fill all tables in DB, need call first start'
  task :load_all_fixtures do
    args = ''
    if ARGV.size > 1
      for i in 1..(ARGV.size - 1)
        args << " " << ARGV[i]
      end
    end
    ruby "./lib/generator.rb #{args}"
    args = "cities,
            countries,
            clubs,
            leagues,
            universes,
            player_first_names,
            player_last_names"



    Rake::Task["db:fixtures:load_and_create_json"].invoke(args)
  end
end