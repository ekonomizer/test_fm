class CreateTemperaments < ActiveRecord::Migration
  def change
    create_table :temperaments do |t|
      t.string :name, :null => false

    end
  end
end
