class RenameResolutionTypeToType < ActiveRecord::Migration
  def self.up
    rename_column :resolutions, :resolution_type, :type
  end

  def self.down
    rename_column :resolutions, :type, :resolution_type
  end
end
