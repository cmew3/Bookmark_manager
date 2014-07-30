require 'spec_helper'
require_relative 'helpers/session'

include SessionHelpers

feature 'User signs up' do

	scenario 'when being logged out' do
		lambda {sign_up}.should change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario 'with a password that does not match' do
		lambda { sign_up('a@a.com','pass','wrong')}.should change(User, :count).by(0)
		expect(current_path).to eq('/users')
		expect(page).to have_content("passwords do not match")

	end

	scenario 'with an email that is already registered' do
		lambda { sign_up }.should change(User, :count).by(1)
		lambda { sign_up }.should change(User, :count).by(0)
		expect(page).to have_content("Email is already registered")
	end


end

feature 'user signs in' do

	before(:each) do
		User.create(:email => "test@test.com",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario 'with correct credentials' do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com','test')
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario 'with incorrect credentials' do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com','not_password')
		expect(page).not_to have_content("Welcome, test@test.com")
	end


end

feature 'user signs out' do

	before(:each) do
		User.create(:email => "test@test.com",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario 'while being signed in' do
		sign_in('test@test.com','test')
		click_button "Sign out"
		expect(page).to have_content("Goodbye!")
		expect(page).not_to have_content("Welcome, test@test.com")
	end

end

feature 'resetting passwords' do

	before(:each) do
		user = User.create(:email => "test@test.com",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario 'when user has forgotten password' do
		visit '/sessions/new'
		click_link 'Forgotten password'
		expect(page).to have_content("Please enter your email address")
		fill_in_email('test@test.com')
		expect(page).to have_content("A link to reset you password will be sent to your email shortly")
	end

	before(:each) do
		user = User.create(:email => "test2@test.com",
					:password => "test2",
					:password_confirmation => "test2",  
					:password_token => "ABCDEFGHIJKLMNO",
					:password_token_timestamp => Time.now-60)
	end

	scenario 'when user follows the email link and enters valid password' do
		visit '/users/reset_password/ABCDEFGHIJKLMNO'
		expect(page).to have_content("please enter a new password")
		fill_in_new_password("new_password","new_password")
		expect(page).to have_content("Welcome, test2@test.com")
	end

	scenario 'when user follows the email link and enters invalid password' do
		visit '/users/reset_password/ABCDEFGHIJKLMNO'
		expect(page).to have_content("please enter a new password")
		fill_in_new_password("new_password","bad_password")
		expect(page).to have_content("Ooops")
	end

	scenario 'does not reset the password if token has timed out' do
		user = User.create(:email => "test3@test.com",
					:password => "test3",
					:password_confirmation => "test3",  
					:password_token => "XYZABCDEFGHIJKLMNO",
					:password_token_timestamp => Time.now-4000)
		visit '/users/reset_password/XYZABCDEFGHIJKLMNO'
		expect(page).not_to have_content("please enter a new password")
		expect(page).to have_content("your password reset has timed out")

	end

end

