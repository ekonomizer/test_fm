# == Schema Information
#
# Table name: universes
#
#  id                         :integer          not null, primary key
#  data                       :hstore
#  filled_now                 :string(255)
#  generate_championship_time :datetime
#

class Universe < ActiveRecord::Base

  hstore_accessor :data, :filled_country_data

  after_save :reset_cache

  FILLED_UNIVERSE = 'filled_universe'
  DEFAULT_FILLED_UNIVERSE_ID = 1

  def self.filled_universe
    Universe.where(filled_now: '1').last
  end

  def self.get_universes_by_country_id value
    #self.where("data @> 'filled_country_id=>:value'", value: value)
    #Universe.where("data ? :value",value:'filled_country_id')
  end

  #def self.cached_filled_universe
  #  Rails.cache.fetch([Universe, FILLED_UNIVERSE]) { Universe.where(filled_now: '1').last }
  #end

  def self.create_next_universe
    universe = self.filled_universe
    if universe
      next_universe = Universe.where("id > ?", universe.id).first
      universe.filled_now = nil
      universe.save
    else
      next_universe = Universe.find(DEFAULT_FILLED_UNIVERSE_ID)
    end

    next_universe.filled_now = '1'
    #next_universe.filled_country_data = default_filled_country_data
    next_universe.save
    next_universe
  end

  private
  def reset_cache
    Rails.cache.delete([Universe, FILLED_UNIVERSE])
    Rails.cache.fetch([Universe, FILLED_UNIVERSE]) { Universe.where(filled_now: '1').last }
  end
end
