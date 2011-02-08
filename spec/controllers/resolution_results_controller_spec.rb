require 'spec_helper'

describe ResolutionResultsController do
  before(:each) do
    @resolution_result = Factory(:resolution_result)
  end
  
  describe "for non-signed in users" do
    it "should deny access" do
      post :update, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  describe "for signed in users" do
    describe "when it's the wrong user" do
      
      before(:each) do
        @user = Factory(:user, :email => Factory.next(:email))
        test_sign_in(@user)
      end
      
      it "should make sure that the user is the resolution owner" do
        post :update, :id => @resolution_result.id
        response.should redirect_to(root_path)
      end
    end
    
    describe "when it's the correct user" do
      before(:each) do
        test_sign_in(@resolution_result.resolution.user)
      end
      describe "with valid params" do
        it "updates the requested resolution result" do
          put :update, :id => @resolution_result, :resolution_result => { 'times_completed' => 2 }
          @resolution_result.reload
          @resolution_result.times_completed.should == 2
        end
      
        it "redirects to the resolution" do
          put :update, :id => @resolution_result, :resolution_result => { 'times_completed' => 2 }
          response.should redirect_to(@resolution_result.resolution)
        end
      end
    end
  end
end
