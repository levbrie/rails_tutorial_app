require 'spec_helper'

describe "Static pages" do
  describe "Home page" do
  	# what's in quotes is for humans, irrelevant to RSpec
    it "should have the h1 'Sample App'" do
      # Run the generator again with the --webrat flag if you want to use webrat
      # methods/matchers
      # original: get static_pages_index_path
      # response.status.should be(200)
      # use Capybara function visit to simulate visiting URI /static_pages/home 
      # in browser
      visit '/static_pages/home'
      # use Capybara page variable to test content in resulting page
      # remember to use bundle exec with command:
      # rspec spec/requests/static_pages_spec.rb
      # to ensure RSpec runs in environment specified by Gemfile
      page.should have_selector('h1', :text => 'Sample App')
    end

    it "should have the title 'Home'" do
      visit '/static_pages/home'
      page.should have_selector('title', 
        :text => "Ruby on Rails Tutorial Sample App | Home")
    end
  end

  describe "Help page" do 
    it "should have the h1 'Help'" do 
      visit '/static_pages/help'
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      page.should have_selector('title', 
        :text => "Ruby on Rails Tutorial Sample App | Help")
    end
  end

  describe "About page" do 
    it "should have the h1 'About'" do 
      visit '/static_pages/about'
      page.should have_selector('h1', :text => "About")
    end

    it "should have the title 'About'" do 
      visit '/static_pages/about'
      page.should have_selector('title', 
        :text => "Ruby on Rails Tutorial Sample App | About")
    end
  end
end
