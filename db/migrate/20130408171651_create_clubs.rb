class CreateClubs < ActiveRecord::Migration
	def change
		create_table :clubs do |t|
			t.string :name_ru, :null => false
			t.string :name_en, :null => false
			t.integer :city_id, :null => false
			#t.integer :user_id, :null => true
			t.integer :country_id, :null => false

			#t.timestamps
		end
	end
end

