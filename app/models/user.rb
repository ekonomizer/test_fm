# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  login      :string(255)
#  password   :string(255)
#  data       :hstore
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  include Authentication
  hstore_accessor :data, :club_id, :base_career, :manager
	#validates :base_career, :inclusion => { :in => %w(footballer large),
  #                                 :message => "%{value} is not a valid base_career" }
  before_create :hash_password

  def hash_password
    self.password = cript_password({login: self.login, password: self.password})
  end


end
