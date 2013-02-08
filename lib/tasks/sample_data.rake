# Rake task for populating the database with sample users 
# uses faker gem for population
namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do	# ensures Rake task has access to local
																	# Rails environment including User model
		make_users
		make_microposts
		make_relationships
	end

	def make_users
		# first user will be an admin - create user:
		admin = User.create!(name: "Example User",
					 		 email: "example@railstutorial.org", 
					 		 password: "foobar", 
					 		 password_confirmation: "foobar")
		admin.toggle!(:admin)			# make the first user an admin
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			# create! raises exception where create returns false
			User.create!(name: name,		
						 email: email, 
						 password: password,
						 password_confirmation: password)
		end		
	end

	def make_microposts
		users = User.all(limit: 6)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end

	# adds following/follower relationships to the sample data
	def make_relationships
		users = User.all
		user = users.first
		followed_users = users[2..50]
		followers 		 = users[3..40]
		followed_users.each { |followed| user.follow!(followed) }
		followers.each 			{ |follower| follower.follow!(user) }
	end
end