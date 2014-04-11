class AddSortOrderToUserClubs < ActiveRecord::Migration
  def change
    add_column :user_clubs, :sort_order, :integer
  end
end
