class CreatePlayerSurnames < ActiveRecord::Migration
  def change
    create_table :player_surnames do |t|
      t.string :surname
    end
  end
end
