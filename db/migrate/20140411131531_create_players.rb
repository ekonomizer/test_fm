class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_club_id
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.integer :age, :null => false
      t.integer :number, :null => false
      t.integer :born_country_id, :null => false
      t.integer :strength, :null => false
      t.integer :temperament_id, :null => false
      t.integer :form, :null => false
      t.integer :mood, :null => false
      t.hstore :skills
      t.integer :match_salary, :null => false
      t.integer :exp, :null => false
      t.integer :captain, :null => false
      t.hstore :position


      t.timestamps
    end
  end
end
