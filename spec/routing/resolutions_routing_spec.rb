require "spec_helper"

describe ResolutionsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/resolutions" }.should route_to(:controller => "resolutions", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/resolutions/new" }.should route_to(:controller => "resolutions", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/resolutions/1" }.should route_to(:controller => "resolutions", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/resolutions/1/edit" }.should route_to(:controller => "resolutions", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/resolutions" }.should route_to(:controller => "resolutions", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/resolutions/1" }.should route_to(:controller => "resolutions", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/resolutions/1" }.should route_to(:controller => "resolutions", :action => "destroy", :id => "1")
    end

  end
end
