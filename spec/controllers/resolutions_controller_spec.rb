require 'spec_helper'

describe ResolutionsController do

  def mock_resolution(stubs={})
    (@mock_resolution ||= mock_model(Resolution).as_null_object).tap do |resolution|
      resolution.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all resolutions as @resolutions" do
      Resolution.stub(:all) { [mock_resolution] }
      get :index
      assigns(:resolutions).should eq([mock_resolution])
    end
  end

  describe "GET show" do
    it "assigns the requested resolution as @resolution" do
      Resolution.stub(:find).with("37") { mock_resolution }
      get :show, :id => "37"
      assigns(:resolution).should be(mock_resolution)
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
      it "assigns a newly created resolution as @resolution" do
        Resolution.stub(:new).with({'these' => 'params'}) { mock_resolution(:save => true) }
        post :create, :resolution => {'these' => 'params'}
        assigns(:resolution).should be(mock_resolution)
      end

      it "redirects to the created resolution" do
        Resolution.stub(:new) { mock_resolution(:save => true) }
        post :create, :resolution => {}
        response.should redirect_to(resolution_url(mock_resolution))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved resolution as @resolution" do
        Resolution.stub(:new).with({'these' => 'params'}) { mock_resolution(:save => false) }
        post :create, :resolution => {'these' => 'params'}
        assigns(:resolution).should be(mock_resolution)
      end

      it "re-renders the 'new' template" do
        Resolution.stub(:new) { mock_resolution(:save => false) }
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

    it "redirects to the resolutions list" do
      Resolution.stub(:find) { mock_resolution }
      delete :destroy, :id => "1"
      response.should redirect_to(resolutions_url)
    end
  end

end
