# == Schema Information
#
# Table name: user_clubs
#
#  id          :integer          not null, primary key
#  club_id     :integer          not null
#  user_id     :integer
#  division    :integer          not null
#  universe_id :integer          not null
#  coins       :integer
#

class UserClub < ActiveRecord::Base
  belongs_to :country
  belongs_to :club
end
