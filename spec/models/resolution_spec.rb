require 'spec_helper'
require 'date'

describe Resolution do

  before(:each) do
    @attr = sample_resolution_attributes
  end
  describe "creation" do

    it "Should not be valid without a title" do
      test_validates_presence(:title)
    end
    it "should not be valid without a start date" do
      test_validates_presence(:start_date)
    end
    it "should not be valid without a number of repetitions" do
      test_validates_presence(:repetitions)
    end
    it "should have an start date that's in the future" do
      @attr[:start_date] = Date.today - 2
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.start_date = Date.today + 2
      resolution.should be_valid
    end
    it "should not be valid without a unit" do
      test_validates_presence(:unit)
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
      test_validates_presence(:period)
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
    it "should not be valid without a number of times" do
      test_validates_presence(:times)
    end
    it "number of times must be a non negative number" do
      resolution = Resolution.new(@attr)
      resolution.times = 'dave'
      resolution.should_not be_valid
      resolution.times = -1
      resolution.should_not be_valid
      resolution.times = 0
      resolution.should_not be_valid
      resolution.times = 1
      resolution.should be_valid
    end    
    it "repetitions must be a non negative number" do
      resolution = Resolution.new(@attr)
      resolution.repetitions = 'dave'
      resolution.should_not be_valid
      resolution.repetitions = -1
      resolution.should_not be_valid
      resolution.repetitions = 0
      resolution.should_not be_valid
      resolution.repetitions = 1
      resolution.should be_valid
    end   
    it "Should create with valid options" do
      resolution = Resolution.create!(@attr)
    end
  end
  
  
  describe "creation of results" do          
    it "should create the name number of results as repetitions required" do
      @resolution = Factory(:resolution)
      @resolution.resolution_results.length.should == 3
    end
    it "should have a first result with its own start date" do
      @resolution = Factory(:resolution)
      @resolution.resolution_results[0].start_date.should == @resolution.start_date
    end
    describe "daily resolutions" do
      before(:each) do
        @resolution = Factory(:resolution, :period => 'day')
      end
      it "should create results with the same start and end date" do
        @resolution.resolution_results.each do |result |
          result.start_date.should == result.end_date
        end 
      end
      it "the last result's start date should be 'repetitions' days later" do
        last_start_date = @resolution.resolution_results.last.start_date
        days_difference = (last_start_date - @resolution.start_date).to_i
        days_difference.should == @resolution.repetitions - 1
      end
    end
    describe "weekly resolutions" do
      before(:each) do
        @resolution = Factory(:resolution, :period => 'week')
      end
      it "should create results with the start and end date 6 days apart" do
        @resolution.resolution_results.each do |result |
          result.end_date.should == result.start_date + 6
        end 
      end
      it "the last result's start date should be 'repetitions' weeks later" do
        last_start_date = @resolution.resolution_results.last.start_date
        days_difference = (last_start_date - @resolution.start_date).to_i
        (@resolution.repetitions - 1).should == days_difference / 7
      end
    end
    describe "monthly resolutions" do
      before(:each) do
        @resolution = Factory(:resolution, :period => 'month')
      end
      it "should create results with the start and end date 1 calendar month - 1 day apart" do
        @resolution.resolution_results.each do |result |
          result.end_date.should == (result.start_date >> 1) - 1
        end 
      end
      pending "how else to we test a month?" do
        
      end
    end
    describe "quarterly resolutions" do
      before(:each) do
        @resolution = Factory(:resolution, :period => 'quarter')
      end
      it "should create results with the start and end date 3 calendar months - 1 day apart" do
        @resolution.resolution_results.each do |result |
          result.end_date.should == (result.start_date >> 3) - 1
        end 
      end
    end
    describe "year resolutions" do
      before(:each) do
        @resolution = Factory(:resolution, :period => 'year')
      end
      it "should create results with the start and end date 1 year - 1 day apart" do
        @resolution.resolution_results.each do |result |
          result.end_date.should == (result.start_date >> 12) - 1
        end 
      end
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
