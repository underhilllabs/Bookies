module Features
  module SessionHelpers
    def sign_up_with(email, password)
      visit new_identity_path 
      fill_in 'Nickname', with: "tester"
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password
      click_button 'Register'
    end

    def sign_in_with(email, password)
      visit login_path 
      fill_in 'Email', with: email
      fill_in 'Password', with: password
      click_button 'Login'
    end

    def sign_in
      user = create(:user)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Login'
    end
  end
end
