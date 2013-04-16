# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  city_id    :integer
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Club < ActiveRecord::Base
	belongs_to :country
end
