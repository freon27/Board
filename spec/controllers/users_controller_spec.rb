require 'spec_helper'

describe UsersController do
  render_views
  def mock_user(stubs={})
    (@mock_user ||= mock_model(User).as_null_object).tap do |user|
      user.stub(stubs) unless stubs.empty?
    end
  end
  describe "for signed in users" do
    before(:each) do
      @user = test_sign_in(Factory(:user))
    end
    describe "GET index" do
      before(:each) do
        second = Factory(:user, :email => "another@example.com")
        third  = Factory(:user, :email => "another@example.net")
        @users = [@user, second, third]
        30.times do
          @users << Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have an element for each user" do
        get :index
        @users.each do |user|
          #response.should have_selector("h1", :content => 'Listing Users')
          response.should have_selector("td", :content => user.name)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector("div.pagination")
        response.should have_selector("span.disabled", :content => "Previous")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "2")
        response.should have_selector("a", :href => "/users?page=2",
                                           :content => "Next")
      end
      
      
    end
  
    describe "GET show" do
      
      it "assigns the requested user as @user" do
        User.stub(:find).with("37") { @user }
        get :show, :id => "37"
        assigns(:user).should be(@user)
      end
      
      it "should show the user's resolutions" do
        #@user = Factory(:user)
        r1 = Factory(:resolution, :user => @user, :title => "Resolution 1")
        r2 = Factory(:resolution, :user => @user, :title => "Resolution 2")
        get :show, :id => @user
        response.should have_selector("a", :href => resolution_path(r1), :content => r1.title)
        response.should have_selector("a", :href => resolution_path(r2), :content => r2.title)
      end
    end
  
    describe "GET new" do
      it "assigns a new user as @user" do
        User.stub(:new) { mock_user }
        get :new
        assigns(:user).should be(mock_user)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested user as @user" do
        User.stub(:find).with("37") { mock_user }
        get :edit, :id => "37"
        assigns(:user).should be(mock_user)
      end
    end
  
    describe "POST create" do
  
      describe "with valid params" do
        it "assigns a newly created user as @user" do
          User.stub(:new).with({'these' => 'params'}) { mock_user(:save => true) }
          post :create, :user => {'these' => 'params'}
          assigns(:user).should be(mock_user)
        end
  
        it "should have a welcome message" do
          User.stub(:new) { mock_user(:save => true) }
          post :create, :user => {}
          flash[:success].should =~ /Welcome #{ mock_user.name }/i
        end
        
        it "should sign the user in" do
          User.stub(:new) { mock_user(:save => true) }
          post :create, :user => {}
          controller.should be_signed_in
        end
        
        it "redirects to the created user" do
          User.stub(:new) { mock_user(:save => true) }
          post :create, :user => {}
          response.should redirect_to(user_url(mock_user))
        end
        
      end
  
      describe "with invalid params" do
        it "assigns a newly created but unsaved user as @user" do
          User.stub(:new).with({'these' => 'params'}) { mock_user(:save => false) }
          post :create, :user => {'these' => 'params'}
          assigns(:user).should be(mock_user)
        end
  
        it "re-renders the 'new' template" do
          User.stub(:new) { mock_user(:save => false) }
          post :create, :user => {}
          response.should render_template("new")
        end
      end
  
    end
  
    describe "PUT update" do
      describe "for valid user" do
        describe "with valid params" do
          before(:each) do
            @attr = { :name => "New Name", :email => "user@example.org",
                      :password => "barbaz", :password_confirmation => "barbaz" }
          end
    
          it "should change the user's attributes" do
            put :update, :id => @user, :user => @attr
            @user.reload
            @user.name.should  == @attr[:name]
            @user.email.should == @attr[:email]
          end
    
          it "should redirect to the user show page" do
            put :update, :id => @user, :user => @attr
            response.should redirect_to(user_path(@user))
          end
    
          it "should have a flash message" do
            put :update, :id => @user, :user => @attr
            flash[:success].should =~ /updated/
          end
        end
        
        describe "with invalid params" do
          before(:each) do
            @attr = { :email => "", :name => "", :password => "",
                    :password_confirmation => "" }
          end
          it "re-renders the 'edit' template" do
             put :update, :id => @user, :user => @attr
            response.should render_template("edit")
          end
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested user" do
        User.should_receive(:find).with("37") { mock_user }
        mock_user.should_receive(:destroy)
        delete :destroy, :id => "37"
      end
  
      it "redirects to the users list" do
        User.stub(:find) { mock_user }
        delete :destroy, :id => "1"
        response.should redirect_to(users_url)
      end
    end
    
  end

  describe "authentication of edit/update pages" do
    
      before(:each) do
        @user = Factory(:user)
      end
  
      describe "for non-signed-in users" do
  
        it "should deny access to 'edit'" do
          get :edit, :id => @user
          response.should redirect_to(signin_path)
        end
        
        it "should deny access to 'show'" do
          get :show, :id => @user
          response.should redirect_to(signin_path)
        end
  
        it "should deny access to 'update'" do
          put :update, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end

  
        it "should deny access to 'index'" do
          put :index, :id => @user, :user => {}
          response.should redirect_to(signin_path)
        end
      end
    describe "for signed-in users" do
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'show'" do
        put :show, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end
  end
end
