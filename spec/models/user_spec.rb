require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :email => "test@test.com",
      :name => 'David',
      :password => 'password1',
      :password_confirmation => 'password1'
    }
  end
  
  describe "creation" do
    it "should not be valid without an email" do
      @attr.delete(:email)
      @user = User.new(@attr)
      @user.should_not be_valid
      @user.email = 'test@test.com'
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
      @user.email = 'test@test.com'
      @user.should be_valid
    end
    pending "should require a unique email address" do
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
