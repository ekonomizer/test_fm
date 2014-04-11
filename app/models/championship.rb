# == Schema Information
#
# Table name: championships
#
#  id         :integer          not null, primary key
#  id_home    :integer          not null
#  id_guest   :integer          not null
#  match_date :datetime         not null
#  division   :integer          not null
#  universe   :integer          not null
#  result     :hstore
#

class Championship < ActiveRecord::Base

  #def self.dates_without_result_by_club_id club_id, dates_count = nil
  #  if dates_count
  #    matches = Championship.where(["result = (?) AND (id_home = (?) OR id_guest = (?)", nil, club_id, club_id]).limit(dates_count)
  #  else
  #    matches = Championship.where(["result = (?) AND (id_home = (?) OR id_guest = (?)", nil, club_id, club_id])
  #  end
  #  matches
  #end


  def self.matches_current_season user_club
    Championship.select(:id_home, :id_guest, :match_date, :result).where(["season = (?) AND universe = (?) AND (id_home = (?) OR id_guest = (?))", user_club.season, user_club.universe_id, user_club.id, user_club.id])
  end

  #def self.last_match_with_result_by_id club_id
  #  Championship.where(["result != (?) AND (id_home = (?) OR id_guest = (?)", nil, club_id, club_id]).last
  #end
end
