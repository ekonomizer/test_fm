class CreatePlayerFirstNames < ActiveRecord::Migration
  def change
    create_table :player_first_names do |t|
      t.string :first_name, :null => false
    end
  end
end
