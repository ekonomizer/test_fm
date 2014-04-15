# == Schema Information
#
# Table name: players
#
#  id              :integer          not null, primary key
#  user_club_id    :integer
#  first_name      :string(255)
#  last_name       :string(255)
#  age             :integer
#  number          :integer
#  born_country_id :integer
#  strength        :integer
#  temperament_id  :integer
#  form            :integer
#  skills          :hstore
#  match_salary    :integer
#  exp             :integer
#  captain         :integer
#  position        :hstore
#  created_at      :datetime
#  updated_at      :datetime
#

class Player < ActiveRecord::Base

end
