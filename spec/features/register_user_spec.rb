require 'rails_helper'

def register_an_account
  visit new_identity_path 
  fill_in 'Nickname', with: "tester"
  fill_in 'Email', with: "tester@test.com"
  fill_in 'Password', with: "s3cr3t"
  fill_in 'Password confirmation', with: "s3cr3t"
  click_button 'Register'
end

feature 'User registers an account' do
  scenario "they register with email" do
    visit new_identity_path 
    fill_in 'Nickname', with: "tester"
    fill_in 'Email', with: "tester@test.com"
    fill_in 'Password', with: "s3cr3t"
    fill_in 'Password confirmation', with: "s3cr3t"
    click_button 'Register'
    expect(page).to have_content("Signed in!")
  end
end
feature 'User signs in' do
  scenario "they successfully sign in" do
    email = "tester@test.com"
    password = "s3cr3t"
    sign_up_with(email, password)

    visit login_path 
    fill_in 'Email', with: "tester@test.com"
    fill_in 'Password', with: "s3cr3t"
    click_button 'Login'
    expect(page).to have_content("Signed in")
  end
end
