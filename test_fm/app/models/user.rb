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
  include Authentication
	store_accessor :data, :club_id, :base_career, :manager
	#validates :base_career, :inclusion => { :in => %w(footballer large),
  #                                 :message => "%{value} is not a valid base_career" }
  before_create :hash_password

  def hash_password
    self.password = cript_password({login: self.login, password: self.password})
  end


end
