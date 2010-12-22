class User < ActiveRecord::Base
  attr_accessor :email, name
  has_many :projects, :class_name => Project.name,
  :foreign_key => "owner"

  validates :email, :presence => true
  validates :name, :presence => true
end
