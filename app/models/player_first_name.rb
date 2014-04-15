# == Schema Information
#
# Table name: player_first_names
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#

class PlayerFirstName < ActiveRecord::Base
  COUNT = 37697

  def self.get_random cnt = 1
    PlayerFirstName.find(MathHelper.get_random(cnt, COUNT))
  end
end
