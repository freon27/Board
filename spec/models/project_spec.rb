require 'spec_helper'

describe Project do
    it "should not be valid without a name" do
      @project = Project.new
      @project.should_not be_valid
      @project.name = 'Project 1'
      @project.should be_valid
    end
end
