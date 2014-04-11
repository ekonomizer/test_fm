begin
  def set_sort_order clubs, country_id, current_division, sort_order
    clubs_for_filling = clubs.where(country_id: country_id, division: current_division)
    return sort_order if clubs_for_filling.empty?
    clubs_for_filling.each do |club|
      club.sort_order = sort_order
      club.save
      sort_order = sort_order + 1
    end
    sort_order
  end

  def reset_user_clubs
    clubs = Club.cached_clubs
    UserClub.all.each do |user_club|
      new_sort_order = clubs[user_club.club_id]
      user_club.sort_order
    end
  end

  def set_clubs_sort_orders clubs
    p 'SET CLUBS SORT ORDERS'
    sort_order = 1
    1.upto(7) do |current_division|
      1.upto(League.cached_count) do |league_id|
        countries_by_league = Country.countries_by_league_id league_id
        countries_by_league.each do |country|
          sort_order = set_sort_order clubs, country.id, current_division, sort_order
        end
      end
    end
    Club.reset_cache
    p 'END SET SORT ORDERS'
  end

  clubs = Club.all
  ActiveRecord::Base.transaction{ set_clubs_sort_orders(clubs) } unless clubs.where(sort_order: nil).empty?
rescue
  p 'ERROR WHEN SET CLUBS SORT ORDERS'
end