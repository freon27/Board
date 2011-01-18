require 'spec_helper'

describe "resolutions/show.html.erb" do
  before(:each) do
    @resolution = assign(:resolution, stub_model(Resolution,
      :title => "Title",
      :description => "MyText",
      :owner => 1,
      :start_date => Date.today + 1,
      :end_date =>  Date.today + 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
