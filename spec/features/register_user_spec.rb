require 'rails_helper'

feature 'User registers an account' do
  scenario "they register with email" do
    visit new_identity_url 
    #visit "/identities/new"
    fill_in 'Nickname', with: "tester"
    fill_in 'Email', with: "tester@test.com"
    fill_in 'Password', with: "s3cr3t"
    fill_in 'Password confirmation', with: "s3cr3t"
    click_button 'Register'
    expect(page).to have_content("Signed in")
  end
end
