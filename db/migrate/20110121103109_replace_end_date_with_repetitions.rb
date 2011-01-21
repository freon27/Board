class ReplaceEndDateWithRepetitions < ActiveRecord::Migration
  def self.up
    remove_column :resolutions, :end_date
    add_column :resolutions, :repetitions, :integer
  end

  def self.down
    add_column :resolutions, :end_date, :date
    remove_column :resolutions, :repetitions
  end
end
