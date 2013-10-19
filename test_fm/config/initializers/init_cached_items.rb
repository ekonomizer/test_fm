p 'INIT START CACHE'
Country.cached_countries
Universe.cached_filled_universe
League.cached_count
Club.cached_clubs

League.all.each do |league|
  Country.countries_by_league_id(league.id)
end
