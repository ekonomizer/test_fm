class AddSortOrderToClubs < ActiveRecord::Migration
  def change
    add_column :clubs, :sort_order, :integer
  end
end
