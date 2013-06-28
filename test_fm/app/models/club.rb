# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  city_id    :integer          not null
#  user_id    :integer
#  country_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Club < ActiveRecord::Base
	belongs_to :country
end
