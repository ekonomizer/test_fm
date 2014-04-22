class ClubsController < ApplicationController

  include ClubsHelper
  include PlayerHelper

	def free_clubs
    Mutex.new.synchronize do
      render :json => get_free_clubs_response
    end
  end

end
