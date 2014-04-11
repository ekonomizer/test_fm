# == Schema Information
#
# Table name: clubs
#
#  id         :integer          not null, primary key
#  name_ru    :string(255)      not null
#  name_en    :string(255)      not null
#  city_id    :integer          not null
#  country_id :integer          not null
#  division   :integer
#

class Club < ActiveRecord::Base
	belongs_to :country
  has_many :user_clubs

  CLUBS = :clubs

  #after_save :reset_cache

  def self.cached_clubs
    Rails.cache.fetch([Club, CLUBS]) { Club.all.order(:id).to_a.unshift(nil) }
  end


  def self.reset_cache
    Rails.cache.delete([Club, CLUBS])
    Rails.cache.fetch([Club, CLUBS]) { Club.all.order(:id).to_a.unshift(nil) }
  end


end
