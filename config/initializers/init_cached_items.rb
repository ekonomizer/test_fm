p 'INIT START CACHE'

def init
  Country.cached_countries
  Universe.cached_filled_universe
  League.cached_count
  Club.cached_clubs

  League.all.each do |league|
    Country.countries_by_league_id(league.id)
  end
end

init
p 'CACHE INITIALIZED'
