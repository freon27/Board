class ChangeResolutionOwnerToUserId < ActiveRecord::Migration
  def self.up
   rename_column :resolutions, :owner, :user_id
  end
 
  def self.down
    rename_column :resolutions, :user_id, :owner
  end
end
