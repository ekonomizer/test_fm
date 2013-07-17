class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.integer :user_id
			t.string :login
			t.hstore :data

			t.timestamps
		end
	end
end
