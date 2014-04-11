class AddGenerateChampionshipTimeToUniverse < ActiveRecord::Migration
  def change
    add_column :universes, :generate_championship_time, :timestamp
  end
end
