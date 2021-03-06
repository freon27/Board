class ResolutionResult < ActiveRecord::Base
  default_scope :order => 'resolution_results.created_at DESC'
  belongs_to :resolution
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :times_completed, :presence => true
  validates_numericality_of :times_completed, :greater_than => -1
  validate :date_validation
  
  def date_validation
    if(end_date && start_date && end_date < start_date) 
      errors.add(:base, "End date must be later than start date")
    end
  end
  
  def current?
    return (self.start_date <= Date.today && self.end_date >= Date.today)
  end
end
