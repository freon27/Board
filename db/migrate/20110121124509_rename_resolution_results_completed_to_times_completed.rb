class RenameResolutionResultsCompletedToTimesCompleted < ActiveRecord::Migration
  def self.up
    rename_column :resolution_results, :completed, :times_completed
  end

  def self.down
    rename_column :resolution_results, :times_completed, :completed
  end
end
