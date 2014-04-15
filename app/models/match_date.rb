# == Schema Information
#
# Table name: match_dates
#
#  id   :integer          not null, primary key
#  date :datetime
#

class MatchDate < ActiveRecord::Base

  OFFSET = 2.hour
  MATCH_DATE = 'cached_match_date'

  def self.cached_match_dates
    Rails.cache.fetch([MatchDate, MATCH_DATE]) { MatchDate.all.order(:id).to_a }
  end

  def self.tomorrow
    Date.tomorrow + 1.day - OFFSET
  end

  def self.current
    Date.tomorrow - OFFSET
  end

  def self.date_by_id id
    self.cached_match_dates.select{|match| match.id == id}[0].date
  end

  def self.id_by_current_date date
    match_date = self.cached_match_dates.select{|match| match.date == date}[0]
    match_date.id if match_date
  end

  #def self.match_dates_when_date_more date
  #  self.cached_match_dates.select{|match| match.date >= date}
  #end

  def self.reset_cache
    Rails.cache.delete([MatchDate, MATCH_DATE])
    Rails.cache.fetch([MatchDate, MATCH_DATE]) { MatchDate.all.order(:id).to_a}
  end
end
