require 'spec_helper'

describe User do
  describe "Initialising user" do
    it "should not be valid without an email" do
      @user = User.new(:name => "David")
      @user.should_not be_valid
      @user.email = 'test@test.com'
      @user.should be_valid
    end
    it "should not be valid without a name" do
      @user = User.new(:email => "test@test.com")
      @user.should_not be_valid
      @user.name = 'David'
      @user.should be_valid
    end
  end
  describe "user created" do
    before(:each) do
      @user = User.new(:email => "test@test.com", :name => 'David')
    end
    it "should start with an empty project list" do
      @user.projects.should be_empty
    end
    it "should allow the user to add a project" do
      @user.projects.build(:name => 'Project 1')
      @user.projects.length.should == 1
    end
  end
end
