require 'spec_helper'

describe ResolutionResult do
  describe "creation" do
    before(:each) do
      @result = Factory(:resolution_result)
    end
    it "should not be valid without a start date" do
      @result.start_date = nil
      @result.should_not be_valid
      @result.start_date = Date.today
      @result.should be_valid
    end
    it "should not be valid without a end date" do
      @result.end_date = nil
      @result.should_not be_valid
      @result.end_date = Date.today + 4
      @result.should be_valid
    end
    it "end date should be greater than start date" do
      @result.end_date = Date.today + 2
      @result.start_date = Date.today + 3
      @result.should_not be_valid
      @result.start_date = Date.today + 1
      @result.should be_valid
    end
    it "should not be valid without a number of times completed" do
      @result.times_completed = nil
      @result.should_not be_valid
      @result.times_completed = 3
      @result.should be_valid
    end
    it "must ensure number of times completed is a positive number or 0" do
      @result.times_completed = 'dave'
      @result.should_not be_valid
      @result.times_completed = -1
      @result.should_not be_valid
      @result.times_completed = 0
      @result.should be_valid
      @result.times_completed = 3
      @result.should be_valid
    end
  end
  describe "resolution associations" do

    before(:each) do
      @resolution = Factory(:resolution)
      @resolution_result = @resolution.resolution_results.create!(sample_resolution_result_attributes)
    end

    it "should have a resolution attribute" do
      @resolution_result.should respond_to(:resolution)
    end

    it "should have the right associated resolution" do
      @resolution_result.resolution_id.should == @resolution.id
      @resolution_result.resolution.should == @resolution
    end
  end
  describe "current?" do
    before(:each) do
      @resolution_result = Factory(:resolution_result)
    end
    it "should return true if the time period spans the current date" do
      @resolution_result.start_date = Date.today - 1
      @resolution_result.end_date = Date.today + 1
      @resolution_result.current?.should == true
    end
    it "should return false if the time period does not span the current date" do
        @resolution_result.start_date = Date.today + 2 
        @resolution_result.end_date = Date.today + 9
        @resolution_result.current?.should == false
    end
  end
end
