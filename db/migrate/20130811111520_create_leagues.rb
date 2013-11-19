class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name_ru, :null => false
      t.string :name_en, :null => false
    end
  end
end
