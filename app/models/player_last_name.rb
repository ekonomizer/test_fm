# == Schema Information
#
# Table name: player_last_names
#
#  id        :integer          not null, primary key
#  last_name :string(255)
#

class PlayerLastName < ActiveRecord::Base
  COUNT = 158792

  def self.get_random cnt = 1
    PlayerLastName.find(MathHelper.get_random(cnt, COUNT))
  end
end
