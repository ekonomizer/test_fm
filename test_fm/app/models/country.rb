# == Schema Information
#
# Table name: countries
#
#  id        :integer          not null, primary key
#  name_ru   :string(255)      not null
#  name_en   :string(255)      not null
#  league_id :integer          not null
#

class Country < ActiveRecord::Base
	has_many :clubs
	has_many :user_clubs

  NAME = :country
  LEAGUE_ID = :league_id

  after_save :reset_cache

  def self.cached_countries
    Rails.cache.fetch([Country, NAME]) { Country.all.order(:id).to_a.unshift(nil) }
  end

  def self.countries_by_league_id league_id
    Rails.cache.fetch([Country, LEAGUE_ID, league_id]) { Country.where(league_id: league_id).order(:id).to_a }
  end


  private
  def reset_cache
    Rails.cache.delete([Country, NAME])
    Rails.cache.fetch([Country, NAME]) { Country.all.order(:id).to_a.unshift(nil) }
    League.all.each do |league|
      Rails.cache.delete([Country, LEAGUE_ID, league.id])
      Rails.cache.fetch([Country, LEAGUE_ID, league.id]) { Country.where(league_id: league.id).order(:id).to_a }
    end
  end

end
