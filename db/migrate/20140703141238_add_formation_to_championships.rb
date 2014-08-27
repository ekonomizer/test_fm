class AddFormationToChampionships < ActiveRecord::Migration
  def change
    add_column :championships, :home_formation, :string
    add_column :championships, :guest_formation, :string
  end
end
