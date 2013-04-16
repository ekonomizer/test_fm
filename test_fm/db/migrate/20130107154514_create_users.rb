class CreateUsers < ActiveRecord::Migration
	def change
		create_table :users do |t|
			t.integer :user_id, :null => false
			t.string :login, :null => false

			t.timestamps
		end
	end
end

