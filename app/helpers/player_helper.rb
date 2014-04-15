module PlayerHelper

  DEFAULT_PLAYERS_CNT = 21
  MIN_PLAYER_AGE = 16
  MAX_PLAYER_AGE = 28
  MIN_PLAYER_NUMBER = 1
  MAX_PLAYER_NUMBER = 50
  MIN_FORM = 1
  MAX_FORM = 100
  DEFAULT_BUCKS_FOR_ONE_POINT = 20

  POSITIONS = [
      "GK",
      "SW",
"LB", "RB", "CB",
"LWB","RWB", "DM",
"LM", "RM", "CM",
"LW", "RW", "AM",
      "SS",
      "CF"]

  SKILLS_FOR_DEFAULT_TEAM = ['speed','shoot_accuracy']

  def create_first_set_players user_club
    players = []
    first_names = PlayerFirstName.get_random DEFAULT_PLAYERS_CNT
    last_names = PlayerLastName.get_random DEFAULT_PLAYERS_CNT
    cached_countries = Country.cached_countries
    cached_countries.shift
    captain_idx = rand(1..DEFAULT_PLAYERS_CNT)
    temperament_ids = Temperament.get_random_ids DEFAULT_PLAYERS_CNT

    1.upto(DEFAULT_PLAYERS_CNT) do |idx|
      player = Player.new
      player.user_club_id = user_club['id']
      player.first_name = first_names[idx - 1].first_name
      player.last_name = last_names[idx - 1].last_name
      player.born_country_id = cached_countries[rand(cached_countries.size)].id
      player.number = rand(MIN_PLAYER_NUMBER..MAX_PLAYER_NUMBER)
      player.form = rand(MIN_FORM..MAX_FORM)
      player.age = rand(MIN_PLAYER_AGE..MAX_PLAYER_AGE)
      player.exp = rand(player.age-2..player.age+3)
      player.strength = player.age
      player.temperament_id = temperament_ids[idx - 1]
      player.captain = (idx == captain_idx)? 1 : 0
      player.mood = 100

      if idx == 1 || idx == 2
        player.position = {POSITIONS[0] => 40}
      elsif idx <= POSITIONS.size
        player.position = {POSITIONS[idx - 1] => 40}
      end
      players << player
    end
    players = set_skills players
    players = add_strength players
    players = set_match_salary players
    Player.import players
#
#сила 150
#скилы 25
#експа 15лет*(1 за год + 0.2 за матч 0.3 за кубок 0.5 за сборную ) 195
#15 + 0.2*40*15 + 0.3*5*15 + 0.5*5*15



  end

  def create_names
    PlayerFirstName.get_random 21
  end

  def set_skills players
    players[rand(players.size)].skills = {SKILLS_FOR_DEFAULT_TEAM[0] => 1}
    players[rand(players.size)].skills = {SKILLS_FOR_DEFAULT_TEAM[1] => 1}
    players
  end

  def set_match_salary players
    players.each do |player|
      summs = 0
      skill_points = 0
      player.skills.each{|k, v| skill_points += v} if player.skills
      points = (player.strength + skill_points) * (player.exp + 100)/100
      player.match_salary = DEFAULT_BUCKS_FOR_ONE_POINT * points
    end
    players
  end



  def add_strength players
    players_strength = 0
    players.each{|player| players_strength += player.strength}
    strength_to_add = DEFAULT_PLAYERS_CNT*MAX_PLAYER_AGE - players_strength
    1.upto(strength_to_add) do
      players[rand(players.size)].strength += 1
    end
    players
  end

end