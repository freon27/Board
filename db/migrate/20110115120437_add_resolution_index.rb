class AddResolutionIndex < ActiveRecord::Migration
  def self.up
    add_index :resolutions, :owner
  end

  def self.down
  end
end
