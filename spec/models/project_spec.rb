require 'spec_helper'

describe Project do
    it "should not be valid without a name" do
      Project.new.should_not be_valid
    end
end
