require 'spec_helper'

describe "resolutions/new.html.erb" do
  before(:each) do
    assign(:resolution, stub_model(Resolution,
      :title => "MyString",
      :description => "MyText",
      :owner => 1
    ).as_new_record)
  end

  it "renders new resolution form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => resolutions_path, :method => "post" do
      assert_select "input#resolution_title", :name => "resolution[title]"
      assert_select "textarea#resolution_description", :name => "resolution[description]"
      assert_select "input#resolution_owner", :name => "resolution[owner]"
    end
  end
end
