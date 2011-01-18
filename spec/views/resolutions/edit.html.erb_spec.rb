require 'spec_helper'

describe "resolutions/edit.html.erb" do
  before(:each) do
    @resolution = assign(:resolution, stub_model(Resolution,
      :title => "MyString",
      :description => "MyText",
      :owner => 1
    ))
  end

  it "renders the edit resolution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => resolution_path(@resolution), :method => "post" do
      assert_select "input#resolution_title", :name => "resolution[title]"
      assert_select "textarea#resolution_description", :name => "resolution[description]"
      assert_select "select#resolution_period", :name => "resolution[period]"
    end
  end
end
