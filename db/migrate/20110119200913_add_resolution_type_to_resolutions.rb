class AddResolutionTypeToResolutions < ActiveRecord::Migration
  def self.up
    add_column :resolutions, :resolution_type, :string
  end

  def self.down
    remove_column :resolutions, :resolution_type
  end
end
