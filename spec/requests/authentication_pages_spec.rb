require 'spec_helper'

describe "AuthenticationPages" do
  subject { page }
  describe "signin page" do
  	before { visit signin_path }

  	# it { should have_selector('h1', 	text: 'Sign in')}
  	# it { should have_selector('title', 	text: 'Sign in')}
    # replacement for above 2 lines, c.f. support/utilities.rb
    it { should have_heading(1, 'Sign in')}
    it { should be_entitled('Sign in')}
  end

  describe "signin" do
  	before { visit signin_path }

  	describe "with invalid information" do
  		before { click_button "Sign in" }

      # it { should have_selector('title',  text: 'Sign in')} replaced by:
  		it { should be_entitled('Sign in')}
  		# no longer needed because of utilities.rb custom RSpec matcher:
      # it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      it {should have_error_message('Invalid')}
  	end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before {valid_signin(user)}   # helper method found in utilities.rb

      it {should have_selector('title', text: user.name)}
      it {should have_link('Profile', href: user_path(user))} 
      it {should have_link('Sign out', href: signout_path)}
      it {should_not have_link('Sign in', href: signin_path)}
    end

    describe "after visiting another page" do
      before { click_link "Home" }
      # page should not have any error messages
      it { should_not have_error_message }
    end
  end
end
