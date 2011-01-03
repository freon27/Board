class Resolution < ActiveRecord::Base
  attr_accessible :title, :description, :start_date, :end_date
  belongs_to :user, :foreign_key => "owner"
  validates :title, :presence => true
  validates :start_date, :presence => true
  validates :end_date, :presence => true

  def validate  
    errors.add_to_base "End date must be in the future" if  end_date && end_date < Date.today
    if(end_date && start_date && end_date < start_date) 
      errors.add_to_base "End date must be later than start date"
    end
  end
end
