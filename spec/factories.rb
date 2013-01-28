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
end