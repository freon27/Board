require 'spec_helper'
require 'date'

describe Resolution do
  before(:each) do
    @attr = sample_resolution_attributes
  end
  describe "creation" do
    it "Should not be valid without a title" do
      @attr.delete(:title)
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.title = 'Test'
      resolution.should be_valid
    end
    it "should not be valid without a start date" do
      @attr.delete(:start_date)
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.start_date = Date.today + 1 
      resolution.should be_valid
    end
    it "should not be valid without an end date" do
      @attr.delete(:end_date)
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.end_date = Date.today + 2 
      resolution.should be_valid
    end
    it "should have an end date that's in the future" do
      @attr[:end_date] = Date.new(1909, 1, 1)
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.end_date = Date.new(2099, 12, 22)
      resolution.should be_valid
    end
    it "should have an end date that's later than the start date" do
      @attr[:start_date] = Date.today + 2
      @attr[:end_date] = Date.today + 1
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.end_date = Date.today + 2
      resolution.should be_valid
    end
    it "should not be valid without a unit" do
      unit = @attr.delete(:unit)
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.unit = unit
      resolution.should be_valid
    end
    it "should not be valid without unit being in the list" do
      resolution = Resolution.new(@attr)
      resolution.should be_valid
      Resolution::UNIT_TYPES.each do | unit |
        resolution.unit = unit
        resolution.should be_valid
      end
      resolution.unit = 'banana'
      resolution.should_not be_valid
    end
    it "should not be valid without period" do
      period = @attr.delete(:period)
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.period = period
      resolution.should be_valid
    end
    it "should only be valid with an accepted period value" do    
      resolution = Resolution.new(@attr)
      resolution.should be_valid
      Resolution::PERIOD_TYPES.each do | period |
        resolution.period = period
        resolution.should be_valid
      end
      resolution.period = 'banana'
      resolution.should_not be_valid
    end
    it "should not be valid without a unit" do
      unit = @attr.delete(:unit)      
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.unit = unit
      resolution.should be_valid
    end    
    it "Should create with valid options" do
      resolution = Resolution.create!(@attr)
    end
  end

  describe "user associations" do

    before(:each) do
      @user = Factory(:user)
      @resolution = @user.resolutions.create!(@attr)
    end

    it "should have a user attribute" do
      @resolution.should respond_to(:user)
    end

    it "should have the right associated user" do
      @resolution.user_id.should == @user.id
      @resolution.user.should == @user
    end
  end
end
