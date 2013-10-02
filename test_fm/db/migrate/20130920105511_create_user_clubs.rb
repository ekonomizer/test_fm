class CreateUserClubs < ActiveRecord::Migration
  def change
    create_table :user_clubs do |t|
      t.integer :club_id, :null => false
      t.integer :user_id, :null => true
      t.integer :division, :null => false
      t.integer :universe_id, :null => false

    end
  end
end
