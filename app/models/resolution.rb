class Resolution < ActiveRecord::Base
  attr_accessible :title, :description, :start_date, :end_date, :period, :user, :times, :unit
  default_scope :order => 'resolutions.created_at DESC'
  belongs_to :user
  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true
  validates :period, :presence => true
  validates :unit, :presence => true
  validates :period, :presence => true
  validate :date_validate
  
  PERIOD_TYPES = ['daily', 'weekly', 'monthly', 'once']
  validates_inclusion_of :period, :in => PERIOD_TYPES

  UNIT_TYPES = ['times', 'hours']
  validates_inclusion_of :unit, :in => UNIT_TYPES

  def date_validate  
    errors.add(:base, "End date must be in the future") if  end_date && end_date < Date.today
    if(end_date && start_date && end_date < start_date) 
      errors.add(:base, "End date must be later than start date")
    end
  end
end
