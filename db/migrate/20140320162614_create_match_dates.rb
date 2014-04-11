class CreateMatchDates < ActiveRecord::Migration
  def change
    create_table :match_dates do |t|
      t.timestamp :date

      #t.timestamps
    end
  end
end
