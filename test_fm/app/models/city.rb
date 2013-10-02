# == Schema Information
#
# Table name: cities
#
#  id         :integer          not null, primary key
#  name_ru    :string(255)      not null
#  name_en    :string(255)      not null
#  country_id :integer          not null
#

class City < ActiveRecord::Base
end
