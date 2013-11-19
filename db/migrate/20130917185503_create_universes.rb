class CreateUniverses < ActiveRecord::Migration
  def change
    create_table :universes do |t|
      t.hstore :data
      t.string :filled_now

    end
  end
end
