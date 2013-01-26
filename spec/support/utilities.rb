# note: files in spec/support directory are automatically included by RSpec
include ApplicationHelper

# code below no longer needed because of include above and 
# file spec/helpers/application_helper_spec.rb
# original full_title creator for application is in app/helpers/application_helper.rb
# def full_title(page_title)
# 	base_title = "Ruby on Rails Tutorial Sample App"
# 	if page_title.empty?
# 		base_title
# 	else
# 		"#{base_title} | #{page_title}"
# 	end
# end

def sign_in(user)
  visit signin_path
  fill_in "Email", 	with: user.email 
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara as well.
  cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_heading do |number, heading|
	match do |page|
		page.should have_selector("h#{number}", text: heading)
	end
end

RSpec::Matchers.define :be_entitled do |title|
	match do |page|
		page.should have_selector('title', text: title)
	end
end


RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end

# check if it has any error message at all - for use with:
# should_not have_error_message (primarily)
RSpec::Matchers.define :have_error_message do 
	match do |page|
		page.should have_selector('div.alert.alert-error')
	end
end
