class CreateChampionships < ActiveRecord::Migration
  def change
    create_table :championships do |t|
      t.integer :id_home, :null => false
      t.integer :id_guest, :null => false
      t.integer :match_date, :null => false
      t.integer :division, :null => false
      t.integer :universe, :null => false
      t.integer :season, :null => false
      t.hstore :result
    end
    add_index :championships, :season
  end
end
