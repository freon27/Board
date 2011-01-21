class Resolution < ActiveRecord::Base
  attr_accessible :title, :description, :start_date, :repetitions, :period, :user, :times, :unit
  default_scope :order => 'resolutions.created_at DESC'
  belongs_to :user
  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :repetitions, :presence => true
  validates :period, :presence => true
  validates :unit, :presence => true
  validates :times, :presence => true
  validates_numericality_of :times, :greater_than => 0
  validates_numericality_of :repetitions, :greater_than => 0
  validate :date_validate
  
  PERIOD_TYPES = ['day', 'week', 'month', 'quarter', 'year']
  validates_inclusion_of :period, :in => PERIOD_TYPES

  UNIT_TYPES = ['times', 'hours']
  validates_inclusion_of :unit, :in => UNIT_TYPES

  def date_validate
    errors.add(:base, "Start date cannot be in the past") if  start_date && start_date < Date.today
  end
end
