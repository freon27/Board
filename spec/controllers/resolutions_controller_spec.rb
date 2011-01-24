require 'spec_helper'

describe ResolutionsController do

  def mock_resolution(stubs={})
    (@mock_resolution ||= mock_model(Resolution).as_null_object).tap do |resolution|
      resolution.stub(stubs) unless stubs.empty?
    end
  end

  describe "For signed in users" do
    
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
    
    describe "checking correct user" do

      pending "should require user to be owner for 'show'" do
        get :show, :id => @user
        response.should redirect_to(root_path)
      end
    
      pending "should require user to be owner for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      pending "should require user to be owner 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end

    end
    describe "GET show" do
      it "assigns the requested resolution as @resolution" do
        Resolution.stub(:find).with("37") { mock_resolution }
        get :show, :id => "37"
        assigns(:resolution).should be(mock_resolution)
      end
      pending "should show a paginated list of resolution results" do
        
      end
      pending "should show a form for the current result period" do
        
      end
      pending "should only show resolution results where the start date has passed" do
        # TODO or should we 
      end
    end
  
    describe "GET new" do
      it "assigns a new resolution as @resolution" do
        Resolution.stub(:new) { mock_resolution }
        get :new
        assigns(:resolution).should be(mock_resolution)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested resolution as @resolution" do
        Resolution.stub(:find).with("37") { mock_resolution }
        get :edit, :id => "37"
        assigns(:resolution).should be(mock_resolution)
      end
    end
  
    describe "POST create" do
  
      describe "with valid params" do
        
        before(:each) do
          @attr = sample_resolution_attributes
        end
        it " should create a new resolution" do
          lambda do
            post :create, :resolution => @attr
          end.should change(Resolution, :count).by(1)
        end
  
        it "redirects to the created resolution" do
          post :create, :resolution => @attr
          response.should redirect_to(user_url(@user))
        end
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved resolution as @resolution" do
          post :create, :resolution => {}
          response.should render_template("new")
        end
  
        it "re-renders the 'new' template" do
          post :create, :resolution => {}
          response.should render_template("new")
        end
      end
  
    end
  
    describe "PUT update" do
  
      describe "with valid params" do
        it "updates the requested resolution" do
          Resolution.should_receive(:find).with("37") { mock_resolution }
          mock_resolution.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :resolution => {'these' => 'params'}
        end
  
        it "assigns the requested resolution as @resolution" do
          Resolution.stub(:find) { mock_resolution(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:resolution).should be(mock_resolution)
        end
  
        it "redirects to the resolution" do
          Resolution.stub(:find) { mock_resolution(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(resolution_url(mock_resolution))
        end
      end
  
      describe "with invalid params" do
        it "assigns the resolution as @resolution" do
          Resolution.stub(:find) { mock_resolution(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:resolution).should be(mock_resolution)
        end
  
        it "re-renders the 'edit' template" do
          Resolution.stub(:find) { mock_resolution(:update_attributes => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
  
    end
  
    describe "DELETE destroy" do
      it "destroys the requested resolution" do
        Resolution.should_receive(:find).with("37") { mock_resolution }
        mock_resolution.should_receive(:destroy)
        delete :destroy, :id => "37"
      end
  
      it "redirects to the user page" do
        Resolution.stub(:find) { mock_resolution }
        delete :destroy, :id => "1"
        response.should redirect_to(user_path(@user))
      end
    end
    
  end
  
  describe "For non signed in users" do

    it "should deny access to 'create'" do
      post :create
      response.should redirect_to(signin_path)
    end

    it "should deny access to 'destroy'" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
end
