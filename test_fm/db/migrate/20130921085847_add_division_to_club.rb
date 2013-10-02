class AddDivisionToClub < ActiveRecord::Migration
  def change
    add_column :clubs, :division, :integer
  end
end
