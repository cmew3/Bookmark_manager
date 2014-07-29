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

