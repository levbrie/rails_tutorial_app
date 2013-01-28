# A factory to simulate User model objects

FactoryGirl.define do
	factory :user do
		# name					"Michael Hartl"	
		# email					"michael@example.com"
		# above name and email replaced with sequence for creating multiple
		sequence(:name) 		{ |n| "Person #{n}"}
		sequence(:email)		{ |n| "person_#{n}@example.com"}
		password 				"foobar"
		password_confirmation	"foobar"
		factory :admin do
			admin true
		end
	end

	# factory for microposts with an association
	factory :micropost do
		content "Lorem ipsum"
		user 			
		# we tell Factory Girl about micropost's associated user just by 
		# including a user in the definition of the factory
	end
end