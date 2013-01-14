require 'spec_helper'

describe "Static pages" do
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }    # page is the subjects of the tests
  describe "Home page" do
    before { visit root_path }  # synonymous with before(:each), this creates
    # a before block to visit root path before each example
    
    it { should have_selector('h1', text: 'Sample App') }
    it {should have_selector 'title', text: full_title('')}
    it {should_not have_selector 'title', text: '| Home'}
  	# what's in quotes is for humans, irrelevant to RSpec
    
      # Run the generator again with the --webrat flag if you want to use webrat
      # methods/matchers
      # original: get static_pages_index_path
      # response.status.should be(200)
      # use Capybara function visit to simulate visiting URI /static_pages/home 
      # in browser
      # use Capybara page variable to test content in resulting page
      # remember to use bundle exec with command:
      # rspec spec/requests/static_pages_spec.rb
      # to ensure RSpec runs in environment specified by Gemfile
      # page.should have_selector('h1', :text => 'Sample App')
  end

  describe "Help page" do 
    before { visit help_path }
    it { should have_selector('h1', text: 'Help') }
    it { should have_selector('title', text: full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_selector('h1', text: 'About')}
    it { should have_selector('title', text: full_title('About')) }
  end

  # old about spec 
  # describe "About page" do 
  #   it "should have the h1 'About'" do 
  #     visit about_path
  #     page.should have_selector('h1', :text => "About")
  #   end

  #   it "should have the title 'About'" do 
  #     visit about_path
  #     page.should have_selector('title', 
  #       :text => "#{base_title} | About")
  #   end
  # end

  describe "Contact page" do 
    before { visit contact_path }
    it {should have_selector('h1', text: 'Contact')}
    it {should have_selector('title', text: full_title('Contact'))}
  end
end
