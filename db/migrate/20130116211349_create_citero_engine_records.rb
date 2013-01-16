class CreateCiteroEngineRecords < ActiveRecord::Migration
  def change
    create_table :citero_engine_records do |t|
      t.string :formatting
      t.string :raw
      t.text :title

      t.timestamps
    end
  end
end