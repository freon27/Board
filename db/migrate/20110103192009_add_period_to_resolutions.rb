class AddPeriodToResolutions < ActiveRecord::Migration
  def self.up
    add_column :resolutions, :period, :string
  end

  def self.down
    remove_column :resolutions, :period
  end
end
