class RemoveDescriptionFromResolutions < ActiveRecord::Migration
  def self.up
    remove_column :resolutions, :description
  end

  def self.down
    add_column :resolutions, :description, :text
  end
end
