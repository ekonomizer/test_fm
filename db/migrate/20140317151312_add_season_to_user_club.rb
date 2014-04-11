class AddSeasonToUserClub < ActiveRecord::Migration
  def change
    add_column :user_clubs, :season, :integer
  end
end
