# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  country_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
end
