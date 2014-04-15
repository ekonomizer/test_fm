class CreatePlayerLastNames < ActiveRecord::Migration
  def change
    create_table :player_last_names do |t|
      t.string :last_name, :null => false
    end
  end
end
