module ClubsHelper

  RUSSIA_COUNTRY_ID = 34
  DEFAULT_FREE_CLUBS_CNT = 15

	def get_free_clubs_response
    #user_clubs = UserClub.joins(:club).where(user_id: nil)
    user_clubs = UserClub.select(:id, :club_id, :universe_id, :sort_order, :division).where(user_id: nil).order("sort_order").limit(DEFAULT_FREE_CLUBS_CNT)

    if user_clubs.empty?
      ActiveRecord::Base.transaction { create_new_universe_user_clubs }
      user_clubs = UserClub.select(:id, :club_id, :universe_id, :sort_order, :division).where(user_id: nil).order("sort_order").limit(DEFAULT_FREE_CLUBS_CNT)
    end
    check_championship_table user_clubs
    get_next_clubs_objects user_clubs
  end

  def check_championship_table user_clubs
    user_clubs = get_only_different_clubs user_clubs
    user_clubs = get_clubs_without_matches user_clubs
    create_championship_table user_clubs unless user_clubs.empty?
  end

  def get_only_different_clubs user_clubs
    different_clubs = []
    clubs_params = []
    user_clubs.each do |user_club|
      current_club_params = [user_club.universe_id, Club.cached_clubs[user_club.club_id].country_id, user_club.division]
      unless clubs_params.include? current_club_params
        clubs_params << current_club_params
        different_clubs << user_club
      end
    end
    different_clubs
  end

  def get_clubs_without_matches user_clubs
    user_clubs_ids = []
    clubs_by_ids = []
    user_clubs.each do |club|
      user_clubs_ids << club.id
      clubs_by_ids[club.id] = club
    end

    championships_dates = Championship.where(["id_home in (?) OR id_guest in (?)", user_clubs_ids, user_clubs_ids])
    championships_dates.each do |date|
      if user_clubs_ids.include?(date.id_home)  || user_clubs_ids.include?(date.id_guest)
        user_clubs_ids.delete date.id_home
        user_clubs_ids.delete date.id_guest
      end
    end
    clubs_without_matches = []
    user_clubs_ids.each do |id|
      clubs_without_matches << clubs_by_ids[id]
    end
    clubs_without_matches
  end

  def create_championship_table user_clubs
    user_clubs.each do |user_club|
      clubs = UserClub.joins(:club).where('user_clubs.universe_id' => user_club.universe_id, 'user_clubs.division' => user_club.division, 'clubs.country_id' => Club.cached_clubs[user_club.club_id].country_id)
      schedule = create_schedule clubs
      championship = []
      match_date_id = MatchDate.where(date: MatchDate.tomorrow).first.id
      schedule.each do |club_pairs_by_day|
        club_pairs_by_day.each do |clubs_pair|
          unless clubs_pair.include? "BYE"
            p clubs_pair[0]
            p clubs_pair[1]
            championship << Championship.new(id_home: clubs_pair[0].id,
                                             id_guest: clubs_pair[1].id,
                                             division: clubs_pair[0].division,
                                             universe: clubs_pair[0].universe_id,
                                             season: clubs_pair[0].season,
                                             match_date: match_date_id)
          end
        end
        match_date_id = match_date_id + 1
      end
      Championship.import championship
    end
  end

  def get_clubs_ids user_clubs
    user_clubs_ids = []
    user_clubs.each do |club|
      user_clubs_ids << club.id
    end
    user_clubs_ids
  end

  def create_schedule(user_clubs)
    user_clubs = user_clubs.to_a
    result = []
    user_clubs = user_clubs + ["BYE"] if user_clubs.size % 2 == 1
    0.upto(user_clubs.size-2) do |i|
        mid = user_clubs.size / 2
        l1 = user_clubs[0...mid]
        l2 = user_clubs[mid..-1]
        l2.reverse!

        # Switch sides after each round
        if i % 2 == 1
            result = result + [ l1.zip(l2) ]
        else
            result = result + [ l2.zip(l1) ]
        end
        user_clubs.insert(1, user_clubs.pop)
    end
    result
  end



  def create_new_universe_user_clubs
    filled_universe = Universe.create_next_universe
    clubs = Club.cached_clubs

    user_clubs_for_save = []
    last_max_user_club_sort_order = UserClub.maximum("sort_order").to_i

    p 'last_max_user_club_sort_order'
    p last_max_user_club_sort_order
    p 'filled_universe'
    p filled_universe

    clubs.each do |club|
      user_clubs_for_save << UserClub.new(club_id: club.id, division: club.division, universe_id: filled_universe.id, coins: ApplicationConfig.default_coins, sort_order: club.sort_order + last_max_user_club_sort_order, season: 1) if club
    end
    UserClub.import user_clubs_for_save
    user_clubs_for_save
  end

  def get_next_clubs_objects user_clubs
    res = []
    cached_clubs = Club.cached_clubs
    cached_countries = Country.cached_countries
    user_clubs.each do |club|
        country_id = cached_clubs[club.club_id].country_id
        raise 'no country id in free_clubs action' unless country_id
        p club
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
end
