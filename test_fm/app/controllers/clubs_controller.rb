class ClubsController < ApplicationController

  RUSSIA_COUNTRY_ID = 34

	def free_clubs
		clubs = UserClub.joins(:club).where(user_id: nil)
    create_new_division_and_clubs if clubs.empty?
    clubs = UserClub.joins(:club).where(user_id: nil)
    res = []
    clubs.each do |club|
        country_id = club.club.country_id
        raise 'no country id in free_clubs action' unless country_id
        res << {id: club.id,
                name: club.club.name_ru,
                country: Country.cached_countries[country_id].name_ru}

    end
		render :json => res
  end

  def create_new_division_and_clubs
    filled_universe = Universe.cached_filled_universe
    p '!!1'
    p filled_universe
    p filled_universe.filled_country_data
    clubs = nil
    if UserClub.count == 0
      clubs = Club.where(country_id: RUSSIA_COUNTRY_ID, division: 1)
    else
      db_filled_data = filled_universe.filled_country_data
      1.upto(League.cached_count) do |idx|
        countries = Country.countries_by_league_id(idx)
        p countries
        p countries.size
        p db_filled_data
        p db_filled_data.size
        if db_filled_data.size < countries.size - 1
          p 'to_possible'
          clubs = possible_clubs_first_division countries, db_filled_data
          p clubs
          break
        elsif db_filled_data.size == countries.size - 1
          p 'to next division'
          clubs = clubs_in_next_division countries, db_filled_data
          break if clubs
        else
          p 'something else'
        end
      end
    end

    if clubs
      create_new_user_clubs clubs, filled_universe
    else
      create_new_universe_defaults_clubs filled_universe
    end
  end

  def clubs_in_next_division countries, db_filled_data
    suitable_countries = []
    need_country = nil
    countries.each do |country|
      suitable_countries << {division: country.division, country_id: country.country_id}
    end

    suitable_countries.select!{|country| country.division > 1}
    suitable_countries.sort!{|a,b| a[:division] <=> b[:division]}

    suitable_countries.each do |country|
      if country.division > db_filled_data[country.country_id]
        need_country = country
        break
      end
    end
    clubs = nil
    if need_country
      clubs = Club.where(country_id: need_country.country_id, division: db_filled_data[need_country.country_id] + 1)
    end
    clubs
  end

  def create_new_user_clubs clubs, filled_universe
    clubs_for_save = []
    clubs.each do |club|
      clubs_for_save << UserClub.new(club_id: club.id, division: club.division, universe_id: filled_universe.id)
    end
    UserClub.import clubs_for_save
    data = filled_universe.filled_country_data
    data[clubs[0].country_id] = clubs[0].division
    filled_universe.filled_country_data = data
    filled_universe.filled_now = '1'
    filled_universe.save
    clubs_for_save
  end

  def create_new_universe_defaults_clubs old_filled_universe
    clubs = Club.where(country_id: RUSSIA_COUNTRY_ID, division: 1)
    old_filled_universe.filled_now = nil
    old_filled_universe.save

    new_filled_universe = Universe.find(old_filled_universe.id + 1)
    create_new_user_clubs clubs, new_filled_universe
  end


  def possible_clubs_first_division countries, db_filled_data
    countries_ids = []
    p 'countries'
    p countries
    countries.each do |country|
      countries_ids << country.id if country
    end
    p 'countries_ids'
    p countries_ids
    p db_filled_data.keys

    dont_added_countries = countries_ids - db_filled_data.keys
    p 'dont_added_countries'
    p dont_added_countries
    rnd_country_id = rand(dont_added_countries.size - 1)

    p 'rnd_country_id '
    p dont_added_countries.size
    p rnd_country_id
    p Club.where(country_id: dont_added_countries[rnd_country_id], division: 1)
    Club.where(country_id: dont_added_countries[rnd_country_id], division: 1)
  end
end
