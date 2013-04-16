# == Schema Information
#
# Table name: contries
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime

class Country < ActiveRecord::Base
	has_many :clubs
end