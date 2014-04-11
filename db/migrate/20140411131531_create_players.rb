class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :user_club_id
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.integer :born_country_id
      t.integer :strength
      t.integer :character_id
      t.integer :form
      t.hstore :skils
      t.integer :salary
      t.hstore :position

      t.timestamps
    end
  end
end
