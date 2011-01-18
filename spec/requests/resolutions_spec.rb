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
          #fill_in :resolution_content, :with => ""
          click_button
          response.should render_template('resolutions/new')
          response.should have_selector("div#error_explanation")
        end.should_not change(Resolution, :count)
      end
    end

    describe "success" do

      it "should make a new resolution" do
        @attr = {
          :title                     => 'test title',
          :description               => 'blash',
          :resolution_start_date_1i  => 2011,
          :resolution_start_date_2i  => 07,
          :resolution_start_date_3i  => 11,
          :resolution_end_date_1i    => 2011,
          :resolution_end_date_2i    => 07,
          :resolution_end_date_3i    => 16,
          :period                    => :daily
        }
        lambda do
          visit '/resolutions/new'
            @attr.each do | key, value |
              fill_in key, :with => value
            end
          click_button
          response.should have_selector("p", :content => @attr[:title])
        end.should change(Resolution, :count).by(1)
      end
    end
  end
end
