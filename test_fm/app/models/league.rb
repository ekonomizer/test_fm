# == Schema Information
#
# Table name: leagues
#
#  id      :integer          not null, primary key
#  name_ru :string(255)      not null
#  name_en :string(255)      not null
#

class League < ActiveRecord::Base

  NAME = :league
  COUNT = :count

  after_save :reset_cache

  def self.cached_leagues
    Rails.cache.fetch([League, NAME]) { League.all.order(:id).to_a.unshift(nil) }
  end

  def self.cached_count
    Rails.cache.fetch([League, COUNT]) { League.count }
  end

  private
  def reset_cache
    Rails.cache.delete([League, NAME])
    Rails.cache.fetch([League, NAME]) { League.all.order(:id).to_a.unshift(nil) }
    Rails.cache.delete([League, COUNT])
    Rails.cache.fetch([League, COUNT]) { League.count }
  end

end
