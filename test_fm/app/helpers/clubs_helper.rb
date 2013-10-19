module ClubsHelper

  RUSSIA_COUNTRY_ID = 34

	def get_free_clubs_response
    #clubs = UserClub.joins(:club).where(user_id: nil)
    clubs = UserClub.select(:id, :club_id).where(user_id: nil)

    if clubs.empty?
      ActiveRecord::Base.transaction{ create_new_division_and_clubs }
      clubs = UserClub.select(:id, :club_id).where(user_id: nil)
    end
    get_free_clubs_objects(clubs)
  end

  def get_free_clubs_objects clubs
    res = []
    cached_clubs = Club.cached_clubs
    cached_countries = Country.cached_countries
    clubs.each do |club|
        country_id = cached_clubs[club.club_id].country_id
        raise 'no country id in free_clubs action' unless country_id
        p country_id
        p club.id
        p cached_clubs[club.club_id].name_ru

        country = cached_countries.select { |country| country && country.id == country_id}[0]
        country_name = country.name_ru
        p country
        p country_name
        # todo country_name = cached_countries[country_id].name_ru need replace when filled countries db table with real data
        res << {id: club.id,
                name: cached_clubs[club.club_id].name_ru,
                country: country_name}
    end
    res
  end

  def create_new_division_and_clubs
    filled_universe = Universe.cached_filled_universe
    p '!!1'
    p filled_universe
    p filled_universe.filled_country_data
    clubs = nil
    if UserClub.count == 0
      #clubs = Club.where(country_id: RUSSIA_COUNTRY_ID, division: 1)
      clubs = Club.cached_clubs.select { |club| club && club.country_id == RUSSIA_COUNTRY_ID && club.division == 1}
    else
      db_filled_data = filled_universe.filled_country_data
      countries_in_searched_leages_cnt = 0
      1.upto(League.cached_count) do |idx|
        countries = Country.countries_by_league_id(idx)
        countries_in_searched_leages_cnt += countries.size
        p countries
        p countries.size
        p db_filled_data
        p db_filled_data.size
        p countries_in_searched_leages_cnt

        if db_filled_data.size < countries_in_searched_leages_cnt
          p 'to_possible'
          clubs = possible_clubs_first_division countries, db_filled_data
          p clubs
          break
        elsif db_filled_data.size == countries_in_searched_leages_cnt
          p 'to next division'
          clubs = clubs_in_next_division countries, db_filled_data
          p clubs
          break if clubs
        else
          p 'something else'
        end
      end
    end

    if clubs
      p 'go to create_new_user_clubs'
      p clubs
      create_new_user_clubs clubs, filled_universe
    else
      create_new_universe_defaults_clubs filled_universe
    end
  end

  def clubs_in_next_division countries, db_filled_data
    suitable_countries = []
    need_country = nil
    countries.each do |country|
      suitable_countries << {divisions: country.divisions, country_id: country.id}
    end

    suitable_countries.select!{|country| country[:divisions] > 1}
    suitable_countries.sort!{|a,b| a[:divisions] <=> b[:divisions]}
    suitable_countries.each do |country|
      if db_filled_data[country[:country_id]] && country[:divisions] > db_filled_data[country[:country_id]]
        need_country = country
        break
      end
    end
    Club.cached_clubs.select { |club| club && club.country_id == need_country[:country_id] && club.division == db_filled_data[need_country[:country_id]] + 1} if need_country
  end

  def create_new_user_clubs clubs, filled_universe
    clubs_for_save = []
    clubs.each do |club|
      clubs_for_save << UserClub.new(club_id: club.id, division: club.division, universe_id: filled_universe.id)
    end
    UserClub.import clubs_for_save
    data = filled_universe.filled_country_data || {}
    data[clubs[0].country_id] = clubs[0].division
    filled_universe.filled_country_data = data
    filled_universe.filled_now = '1'
    filled_universe.save!
    clubs_for_save
  end

  def create_new_universe_defaults_clubs old_filled_universe
    p 'in create_new_universe_defaults_clubs'
    clubs = Club.cached_clubs.select { |club| club && club.country_id == RUSSIA_COUNTRY_ID && club.division == 1}
    old_filled_universe.filled_now = nil
    old_filled_universe.save!
    p 'default clubs'
    p clubs

    new_filled_universe = Universe.find(old_filled_universe.id + 1)
    create_new_user_clubs clubs, new_filled_universe
  end


  def possible_clubs_first_division countries, db_filled_data
    countries_ids = []
    p 'countries'
    p countries
    countries.each do |country|
      countries_ids << country.id
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
    p Club.cached_clubs.select { |club| club && club.country_id == dont_added_countries[rnd_country_id] && club.division == 1}
    Club.cached_clubs.select { |club| club && club.country_id == dont_added_countries[rnd_country_id] && club.division == 1}
  end
end
