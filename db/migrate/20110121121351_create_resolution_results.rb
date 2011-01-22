class CreateResolutionResults < ActiveRecord::Migration
  def self.up
    create_table :resolution_results do |t|
      t.integer :resolution_id
      t.date :start_date
      t.date :end_date
      t.integer :completed

      t.timestamps
    end
  end

  def self.down
    drop_table :resolution_results
  end
end
