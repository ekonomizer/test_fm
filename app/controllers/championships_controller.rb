class ChampionshipsController < ApplicationController
  include PlayerHelper

  def set_formation
    p 'set_formation'
    p params
    raise "no need params in set_formation next_match_id=#{params[:next_match_id]},formation=#{params[:formation]}"if !params[:next_match_id] || !params[:formation]
    need_match = Championship.find params[:next_match_id].to_i
    club_id = User.where(:user_id => params[:user_id]).first.club_id

    #positions_with_player_ids = params[:formation].split(',')
    #positions_with_player_ids.each do |str|
    #  position_with_player_id = str.split(':')
    #end
    #POSITIONS[]

    if need_match.id_home == club_id
      need_match.home_formation = params[:formation]
      need_match.save!
    elsif need_match.id_guest == club_id
      need_match.guest_formation = params[:formation]
      need_match.save!
    end

    render :json => {success_create: true}
  end
end