class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.integer :user_id
			t.string :login
      t.string :password
			t.hstore :data

			t.timestamps
		end
	end
end
