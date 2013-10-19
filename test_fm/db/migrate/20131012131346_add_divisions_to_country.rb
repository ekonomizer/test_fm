class AddDivisionsToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :divisions, :integer
  end
end
