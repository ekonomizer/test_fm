class Temperament < ActiveRecord::Base

  TEMPERAMENTS = :temperaments
  COUNT = 4

  def self.cached_temperaments
    Rails.cache.fetch([Temperament, TEMPERAMENTS]) { Temperament.all.order(:id).to_a }
  end

  def self.get_random_ids cnt = 1
    rand_ids = []
    1.upto(cnt) do
      rand_ids << rand(COUNT)
    end
    rand_ids
  end


  def self.reset_cache
    Rails.cache.delete([Temperament, TEMPERAMENTS])
    Rails.cache.fetch([Temperament, TEMPERAMENTS]) { Temperament.all.order(:id).to_a }
  end

end
