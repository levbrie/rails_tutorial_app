# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do
	before {@user = User.new(name: "Example User", email: "user@example.com",
							password: "foobar", 
							password_confirmation: "foobar")}
	subject {@user}

	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should respond_to(:remember_token)}
	it {should respond_to(:admin)}
	# require a User object to respond to authenticate
	it {should respond_to(:authenticate)}
	it {should respond_to(:microposts)}
	it {should respond_to(:feed)}		# feed of microposts on home page

	it {should be_valid}	# sanity check to verify that @user
	# remember that whenever an object responds to a boolean foo? rspec
	# has a corresponding test method called be_foo
	it {should_not be_admin}

	# ex 9.1 verify User admin attribute isn't accessible, follows listing 10.8
	describe "accessible attributes" do
		it "should not allow access to admin" do
			expect do
				User.new(admin: @user.admin)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

	describe "with admin attribute set to 'true'" do
		before { @user.toggle!(:admin) }

		it { should be_admin }
	end
	describe "when name is not present" do
		before {@user.name = " "}  	# sets user's name invalid blank value
		it {should_not be_valid}	# checks this user object is not valid
	end

	describe "when email is not present" do
		before {@user.email = " "}
		it {should_not be_valid}
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }  # this doesn't constrain length
		it { should_not be_valid }		
		# it gives a name that's too long and expects it to return false
		# when testing for validity.  like presence, it depends on validation
		# at the model level (i.e. in app/models/user.rb)
	end

	# email format validation
	# we'll use validations in the model to actually validate, this just
	# checks that are validations are doing what we expect by offering a
	# few good examples invalid and then valid email addresses
	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
							foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	# uniqueness test for email addresses (prevents duplicate usernames)
	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { should_not be_valid }
	end

	# a helper test for email downcasing
	describe "email address with mixed case" do
		let(:mixed_case_email) { "Foo@ExAMPle.CoM" } 
		it "should be saved as all lower-case" do
			@user.email = mixed_case_email
			@user.save
			@user.reload.email.should == mixed_case_email.downcase
		end
	end

	# make sure password is not blank
	describe "when password is not present" do 
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	# test for password and pass confirm mismatch
	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	# special test for when confirmation is nil (only possible at console)
	# cf. Michael Hartl Ruby on Rails Tutorial 6.3.2 (considers this a bug)
	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		# we must save to the db because this is not a real user
		# it's a test user that's been created just now, and we've got
		# to make sure the database retrieval and check for password works
		# so we've got to first save to db and then check it (in other words, 
		# artificially create an example complete with a user in the db - that
		# is, this user)
		before { @user.save }		
		# saving user to db enables it to be retrieved using find_by_email
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { 
				found_user.authenticate("invalid") 
			}
			it { should_not == user_for_invalid_password }
			# specify is a synonym for it used when it would sound unnatural
			# could be: it { user_for_invalid_password.should be_false }
			specify { user_for_invalid_password.should be_false }
		end

		# test to ensure password is at least 6 chars long
		describe "with a password that's too short" do
			before { @user.password = @user.password_confirmation = "a" * 5 }
			it { should be_invalid }
		end
	end

	describe "remember token" do
		before { @user.save }
		# its applies subsequent test to given attribute rather than subject of 
		# test (see subject @ user above for example)
		# the line below is equivalent to: 
		# it { @user.remember_token.should_not be_blank }
		its(:remember_token) { should_not be_blank }
	end

	describe "micropost associations" do
		before {@user.save}
		let!(:older_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_micropost) do
			FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
		end

		it "should have the right microposts in the right order" do
			@user.microposts.should == [newer_micropost, older_micropost]
		end

		it "should destroy associated microposts" do
			microposts = @user.microposts
			@user.destroy
			microposts.each do |micropost|
				Micropost.find_by_id(micropost.id).should be_nil
				# to use find, which raises an exception, we would need:
				# lambda do
				# 	Micropost.find(micropost.id)
				# end.should raise_error(ActiveRecord::RecordNotFound)
			end
		end

		describe "status" do
			let(:unfollowed_post) do
				FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
			end

			# the array include? method (should include in RSpec boolean convention)
			# checks if an array includes the given element
			its(:feed) {should include(newer_micropost)}	
			its(:feed) {should include(older_micropost)}
			its(:feed) {should_not include(unfollowed_post)}
		end
	end
end
