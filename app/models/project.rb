class Project < ActiveRecord::Base
  attr_accessor :name
  belongs_to :user, :foreign_key => "owner"
  validates :name, :presence => true
end
 