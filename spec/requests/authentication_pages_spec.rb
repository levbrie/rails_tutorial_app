 require 'spec_helper'

describe "Authentication" do
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

    describe "after visiting another page" do
      before { click_link "Home" }
      # page should not have any error messages
      it { should_not have_error_message }
    end
  end

  describe "with valid information" do
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }   # helper method found in utilities.rb

    it {should have_selector('title', text: user.name)}
    it {should have_link('Profile', href: user_path(user))} 
    it {should have_link('Settings', href: edit_user_path(user))}
    it {should have_link('Sign out', href: signout_path)}
    it {should_not have_link('Sign in', href: signin_path)}

    describe "submitting to the create action" do
      before {post users_path}
      specify {response.should redirect_to(user_path(user))}
    end
  end

  describe "with invalid information" do
    it {should_not have_link('Profile')} 
    it {should_not have_link('Settings')}
  end

  describe "authorization" do
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          # fill_in "Email",    with: user.email
          # fill_in "Password", with: user.password
          # click_button "Sign in"
          sign_in user
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            page.should be_entitled('Edit user')
          end

          describe "when signing in again" do
            before do
              visit signin_path
              sign_in user
            end

            it "should render the default (profile) page" do
              page.should be_entitled(user.name)
            end
          end
        end
      end

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user)}
          it {should be_entitled('Sign in')}
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        # testing that index action, which displays all users, is protected
        describe "visiting the user index" do
          before { visit users_path }
          it { should be_entitled('Sign in')}
        end
      end

      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before {post microposts_path}
          specify {response.should redirect_to(signin_path)}
        end

        describe "submitting to the destroy action" do
          before do
            micropost = FactoryGirl.create(:micropost)
            delete micropost_path(micropost)
          end
          specify {response.should redirect_to(signin_path)}
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before {sign_in user}

      describe "visiting Users#edit page" do
        before {visit edit_user_path(wrong_user)}
        it {should_not be_entitled(full_title('Edit user'))}
      end

      describe "submitting a PUT request to the Users#update action" do
        before {put user_path(wrong_user)}
        specify {response.should redirect_to(root_path)}
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before {delete user_path(user)}   # try to delete user
        # make sure it redirects to home page instead of deleting user
        specify {response.should redirect_to(root_path)} 
      end
    end
  end
end
