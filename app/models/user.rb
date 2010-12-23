class User < ActiveRecord::Base
  attr_accessor :email, name
  has_many :projects, :class_name => Project.name,
    :foreign_key => "owner"
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => { :case_sensitive => false } 
  validates :name,  :presence => true,
                    :length => { :maximum => 20 }
end
