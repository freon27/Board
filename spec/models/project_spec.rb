require 'spec_helper'

describe Project do
    it "should not be valid without a name" do
      @project = Project.new(:owner => 1)
      @project.should_not be_valid
      @project.name = 'Project 1'
      @project.should be_valid
    end
    it "should not be valid without an owner" do
      @project = Project.new(:name => 'Project 1')
      @project.should_not be_valid
    end
end
