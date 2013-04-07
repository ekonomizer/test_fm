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

end
