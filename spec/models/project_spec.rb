require 'spec_helper'

describe Project do
    describe "object initialization" do
        before(:each) do
            @attr = {:name => 'Project 1', :owner => 1}
        end
        it "should not be valid without a name" do
          @attr.delete(:name)
          @project = Project.new(@attr)
          @project.should_not be_valid
          @project.name = 'Project 1'
          @project.should be_valid
        end
        it "should not be valid without an owner" do
          @attr.delete(:owner)
          @project = Project.new(@attr)
          @project.should_not be_valid
        end
    end
end
