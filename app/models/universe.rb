# == Schema Information
#
# Table name: universes
#
#  id         :integer          not null, primary key
#  data       :hstore
#  filled_now :string(255)
#

class Universe < ActiveRecord::Base

  hstore_accessor :data, :filled_country_data

  after_save :reset_cache

  FILLED_UNIVERSE = 'filled_universe'
  DEFAULT_FILLED_UNIVERSE_ID = 1
  DEFAULT_FILLED_COUNTRY_ID = 34

  def self.filled_universe

  end

  def self.get_universes_by_country_id value
    #self.where("data @> 'filled_country_id=>:value'", value: value)
    #Universe.where("data ? :value",value:'filled_country_id')
  end



  def self.cached_filled_universe
    Rails.cache.fetch([Universe, FILLED_UNIVERSE]) { Universe.where(filled_now: '1').last } || Universe.set_default_active_universe
  end

  def self.set_default_active_universe
    universe = Universe.find(DEFAULT_FILLED_UNIVERSE_ID)
    universe.filled_now = '1'
    universe.filled_country_data = {DEFAULT_FILLED_COUNTRY_ID => 1}
    universe.save
    universe
  end

  private
  def reset_cache
    Rails.cache.delete([Universe, FILLED_UNIVERSE])
    Rails.cache.fetch([Universe, FILLED_UNIVERSE]) { Universe.where(filled_now: '1').last }
  end
end
