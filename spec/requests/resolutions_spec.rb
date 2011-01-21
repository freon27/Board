require 'spec_helper'

describe "Resolutions" do
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end

  describe "creation" do

    describe "failure" do

      it "should not make a new resolution" do
        lambda do
          visit '/resolutions/new'
          fill_in 'resolution_title', :with => ""
          click_button
          response.should render_template('resolutions/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Resolution, :count)
      end
    end

    describe "success" do

      it "should make a new resolution" do
        @attr = {
          'resolution_title'          => 'test title',
          'resolution_start_date_1i'  => 2011,
          'resolution_start_date_2i'  => 07,
          'resolution_start_date_3i'  => 11,
          'resolution_repetitions'    => 3,
          'resolution_period'         => 'day',
          'resolution_unit'           => 'hours',
          'resolution_times'          => 3
        }
        lambda do
          visit '/resolutions/new'
            @attr.each do | key, value |
              fill_in key, :with => value
            end
          click_button
          response.should have_selector("a", :content => @attr[:title])
        end.should change(Resolution, :count).by(1)
      end
    end
  end
end
