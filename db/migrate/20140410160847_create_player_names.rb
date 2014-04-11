class CreatePlayerNames < ActiveRecord::Migration
  def change
    create_table :player_names do |t|
      t.string :name
    end
  end
end
