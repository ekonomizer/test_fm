class CreateCountries < ActiveRecord::Migration
  def change
	  create_table :countries do |t|
		  t.string :name_ru, :null => false
		  t.string :name_en, :null => false
		  t.integer :league_id, :null => false

		  #t.timestamps
	  end
  end
end
