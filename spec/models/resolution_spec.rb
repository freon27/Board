require 'spec_helper'
require 'date'

describe Resolution do
  before(:each) do
    @attr = {
      :title => 'Sample resolution 1',
      :description => 'This is a sample description',
      :start_date => Date.today + 1 ,
      :end_date => Date.today + 2,
      :period => :weekly
    }
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
    it "should not be valid without period" do
      @attr.delete(:period)
      resolution = Resolution.new(@attr)
      resolution.should_not be_valid
      resolution.period = :weekly
      resolution.should be_valid
    end
    it "should only be valid with an accepted period value" do
      period_values = [
        :daily,
        :weekly,
        :monthly,
        :once
      ]
      resolution = Resolution.new(@attr)
      resolution.should be_valid
      period_values.each do | period |
        resolution.period = period
        resolution.should be_valid
      end
      resolution.period = :biannual
      resolution.should_not be_valid
    end
  end
end
