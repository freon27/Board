class AddColumnTimesToResolutions < ActiveRecord::Migration
  def self.up
    add_column :resolutions, :times, :integer
  end

  def self.down
    remove_column :resolutions, :times
  end
end
