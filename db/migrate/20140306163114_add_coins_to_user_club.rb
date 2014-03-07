class AddCoinsToUserClub < ActiveRecord::Migration
  def change
    add_column :user_clubs, :coins, :integer
  end
end
