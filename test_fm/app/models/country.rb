# == Schema Information
#
# Table name: countries
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Country < ActiveRecord::Base
	has_many :clubs

  NAME = :country

  def self.init_cache
    Rails.cache.fetch([self, NAME]) { self.all.to_a }
  end

  def self.cached_countries
    Rails.cache.fetch(NAME)
  end
end
