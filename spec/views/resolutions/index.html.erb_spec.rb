require 'spec_helper'

describe "resolutions/index.html.erb" do
  before(:each) do
    assign(:resolutions, [
      stub_model(Resolution,
        :title => "Title",
        :description => "MyText",
        :owner => 1
      ),
      stub_model(Resolution,
        :title => "Title",
        :description => "MyText",
        :owner => 1
      )
    ])
  end

  it "renders a list of resolutions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
