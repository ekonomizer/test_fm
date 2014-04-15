module UsersHelper

  def user_stats user, user_club = nil
    data = user.data
    user_club = UserClub.find(user.data['club_id']) unless user_club
    raise "UsersHelper user_stats. no user_club with id = #{data['club_id']}" unless user_club

    cached_club = Club.cached_clubs[user_club.club_id]
    calendar = Championship.matches_current_season(user_club)
    data['calendar'] = calendar
    data['opponents'] = opponents calendar, user_club
    data['club_id'] = cached_club.id
    data['user_club_id'] = user_club.id
    data['division'] = user_club.division
    data['coins'] = user_club.coins
    data['players'] = Player.where(user_club_id: user_club.id)
    p data
    data
  end

  def opponents calendar, user_club
    result = []
    opponents_ids = []
    calendar.each do |day|
      if day['id_home'] != user_club.id
        opponents_ids << day['id_home']
      elsif day['id_guest'] != user_club.id
        opponents_ids << day['id_guest']
      end
    end
    UserClub.select(:id, :club_id, :user_id, :division, :coins).where(id: opponents_ids).to_a unless opponents_ids.empty?
  end

end
