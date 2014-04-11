desc 'End of day!!'
task :execute_end_of_day => :environment do

  def generate_championship universe

  end


  Universe.where(season: !nil).each do |universe|
    if !universe.generate_championship_time || universe.generate_championship_time <= Time.now
      generate_championship universe
    end
  end
end

