# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  login      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	store_accessor :data, :club_id, :base_career, :manager
	validates :base_career, :inclusion => { :in => %w(footballerr large),
                                   :message => "%{value} is not a valid base_career" }
end
