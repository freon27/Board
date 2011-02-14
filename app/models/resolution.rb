class Resolution < ActiveRecord::Base
  attr_accessible :title, :start_date, :repetitions, :period, :user, :times, :unit
  default_scope :order => 'resolutions.created_at DESC'
  
  belongs_to :user
  has_many :resolution_results, :dependent => :destroy
  
  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :repetitions, :presence => true
  validates :period, :presence => true
  validates :unit, :presence => true
  validates :times, :presence => true
  validates_numericality_of :times, :greater_than => 0
  validates_numericality_of :repetitions, :greater_than => 0
  
  after_create :create_results
  
  PERIOD_TYPES = ['day', 'week', 'month', 'quarter', 'year']
  validates_inclusion_of :period, :in => PERIOD_TYPES

  UNIT_TYPES = ['times', 'hours']
  validates_inclusion_of :unit, :in => UNIT_TYPES
  
  def create_results
    period_start_date = self.start_date
    repetitions.times do | i |
      resolution = self.resolution_results.build({
        :start_date => period_start_date,
        :end_date => get_end_date(period_start_date),
        :times_completed => 0
      })
      resolution.save # TODO do we need some error checking here
      period_start_date = resolution.end_date + 1
    end
  end
  
  private
    def get_end_date(start_date)
      case self.period
      when 'day' 
        return start_date
      when 'week'
        return start_date + 6
      when 'month'
        return (start_date >> 1) - 1
      when 'quarter'
        return (start_date >> 3) - 1
      when 'year'
        return (start_date >> 12) - 1
      else
        # TODO add exception for unknown period
      end
    end
    
end
