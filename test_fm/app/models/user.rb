# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  login      :string(255)      not null
#  data       :hstore
#  created_at :datetime
#  updated_at :datetime
#  password   :string(255)
#

class User < ActiveRecord::Base
	store_accessor :data, :club_id, :base_career, :manager
	validates :base_career, :inclusion => { :in => %w(footballer large),
                                   :message => "%{value} is not a valid base_career" }
end
