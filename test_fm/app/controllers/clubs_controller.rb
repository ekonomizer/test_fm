class ClubsController < ApplicationController

	def free_clubs
		clubs = Club.joins(:country).where('user_id is NULL')
		res = []
		clubs.each do |club|
			res << {id: club.id, name: club.name, country: club.country.name}
		end
		render :json => res
	end

end
