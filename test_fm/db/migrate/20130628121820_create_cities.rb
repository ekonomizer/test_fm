class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :name_ru, :null => false
      t.string :name_en, :null => false
      t.integer :country_id, :null => false

      #t.timestamps
    end
  end
end
