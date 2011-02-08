require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :email                  => "test1@test.com",
      :name                   => 'David',
      :password               => 'password1',
      :password_confirmation  => 'password1'
    }
  end
  
  describe "creation" do
    it "should not be valid without an email" do
      @attr.delete(:email)
      @user = User.new(@attr)
      @user.should_not be_valid
      @user.email = 'test1@test.com'
      @user.should be_valid
    end
    it "should not be valid without a name" do
      @attr.delete(:name)
      @user = User.new(@attr)
      @user.should_not be_valid
      @user.name = 'David'
      @user.should be_valid
    end
    it "should not allow the name to be more than 20 characters" do
      @attr[:name] = "a" * 21
      @user = User.new(@attr)
      @user.should_not be_valid
      @user.name = 'David'
      @user.should be_valid
    end
    it "should only allow valid email addresses" do
      @attr[:email] = "Some Internal : Email Format"
      @user = User.new(@attr)
      @user.should_not be_valid
      @user.email = 'test1@test.com'
      @user.should be_valid
    end
    it "should require a unique email address" do
      upcased_email = @attr[:email].upcase
      User.create(@attr.merge(:email => upcased_email))
      user_with_duplicate_email = User.new(@attr)
      user_with_duplicate_email.should_not be_valid
    end
    it "should require a password" do
      @user = User.new(:name => 'David', :email => "test@test.com")
      @user.should_not be_valid
    end
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
    it "should have an encrypted password attribute" do
      @user = User.create!(@attr)
      @user.should respond_to(:encrypted_password)
    end
    it "should set the encrypted password" do
      @user = User.create!(@attr)
      @user.encrypted_password.should_not be_blank
    end
  end
  describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end    

      it "should be false if the passwords don't match" do
        @user.has_password?("invalid").should be_false
      end 
    end
    
    describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end
    end
  end
  
  
  describe "resolution associations" do
    before(:each) do
      @user = User.create(@attr)
      @r1 = Factory(:resolution, :user => @user, :created_at => 1.day.ago)
      @r2 = Factory(:resolution, :user => @user, :created_at => 1.hour.ago)
    end
    it "should have a resolutions attribute" do
      @user.should respond_to(:resolutions)
    end
    
    it "should have the right resolutions in the right order" do
      @user.resolutions.should == [@r2, @r1]
    end
    
    it "should destroy associated resolutions" do
      @user.destroy
      [@r1, @r2].each do |resolutions|
        Resolution.find_by_id(resolutions.id).should be_nil
      end
    end
  end
  
  
  describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end
    
    it "should not be an admin by default" do
      @user.should_not be_admin
    end
    
    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
end
