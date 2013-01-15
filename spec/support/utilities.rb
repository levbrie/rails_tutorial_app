# note: files in spec/support directory are automatically included by RSpec

include ApplicationHelper

# code below no longer needd because of include above and 
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