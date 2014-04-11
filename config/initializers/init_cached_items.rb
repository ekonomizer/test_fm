p 'INIT START CACHE'

begin
  def init
    Country.cached_countries
    #Universe.cached_filled_universe
    League.cached_count
    Club.cached_clubs

    League.all.each do |league|
      Country.countries_by_league_id(league.id)
    end
  end
  p ApplicationConfig.generate_championship_date == Time.now
  init
  p 'CACHE INITIALIZED'
rescue
  p 'ERROR WHEN INITIALIZE CACHE'
end