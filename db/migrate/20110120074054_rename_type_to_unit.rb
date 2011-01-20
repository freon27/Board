class RenameTypeToUnit < ActiveRecord::Migration
  def self.up
    rename_column :resolutions, :type, :unit
  end

  def self.down
    rename_column :resolutions, :unit, :type
  end
end
