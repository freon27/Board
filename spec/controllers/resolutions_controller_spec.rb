require 'spec_helper'

describe ResolutionsController do

  def mock_resolution(stubs={})
    (@mock_resolution ||= mock_model(Resolution).as_null_object).tap do |resolution|
      resolution.stub(stubs) unless stubs.empty?
    end
  end

  describe "For signed in users" do
    describe "for wrong user" do
      before(:each) do
        @user = test_sign_in(Factory(:user, :email => Factory.next(:email) ))
        @resolution = Factory(:resolution)
      end
    
      it "should require user to be owner for 'show'" do
        get :show, :id => @resolution 
        response.should redirect_to(root_path)
      end
    
      it "should require user to be owner for 'edit'" do
        get :edit, :id => @resolution
        response.should redirect_to(root_path)
      end

      it "should require user to be owner 'update'" do
        put :update, :id => @resolution
        response.should redirect_to(root_path)
      end
      
      it "should require user to be owner 'destroy'" do
        delete :destroy, :id => @resolution
        response.should redirect_to(root_path)
      end
    end
    
    describe "for correct user" do
      before(:each) do
        @resolution = Factory(:resolution)
        @user = @resolution.user
        test_sign_in(@user)
      end
      
      describe "GET show" do
        pending "should show a paginated list of resolution results" do
          
        end
        pending "should show a form for the current result period" do
          
        end
        pending "should only show resolution results where the start date has passed" do
          # TODO or should we 
        end
      end
    
      describe "GET new" do
        it "should be succesful" do
          get :new
          response.should be_success
        end
        
      end
    
      describe "GET edit" do  
        it "should be succesful" do
          get :edit, :id => @resolution
          response.should be_success
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

          it "should associate the new resolution with the logged in user" do
            post :create, :resolution => @attr
            assigns(:resolution).user.id.should == @user.id
          end
    
          it "redirects to the user page" do
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
            put :update, :id => @resolution, :resolution => {'title' => 'new title'}
            @resolution.reload
            @resolution.title.should == 'new title'
          end
    
          it "redirects to the resolution" do
            put :update, :id => @resolution
            response.should redirect_to(resolution_url(@resolution))
          end
        end
    
        describe "with invalid params" do
          it "re-renders the 'edit' template" do
            put :update, :id => @resolution, :resolution => { 'title' => ''}
            response.should render_template("edit")
          end
        end
    
      end
    
      describe "DELETE destroy" do
        it "destroys the requested resolution" do
          lambda do
            delete :destroy, :id => @resolution
          end.should change(Resolution, :count).by(-1)
        end
    
        it "redirects to the user page" do
          delete :destroy, :id => @resolution
          response.should redirect_to(user_path(@user))
        end
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
