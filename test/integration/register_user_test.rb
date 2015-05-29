require 'test_helper'
class RegisterUserTest < ActionDispatch::IntegrationTest
  #test "registers plain user account" do
  def test_register_plain_user_account
    visit "/identities/new"
    #visit new_identity_path 
    fill_in 'Nickname', with: "tester"
    fill_in 'Email', with: "tester@test.com"
    fill_in 'Password', with: "s3cr3t"
    fill_in 'Password confirmation', with: "s3cr3t"
    click_button 'Register'
    page.assert_text("Signed in!")
  end
end
