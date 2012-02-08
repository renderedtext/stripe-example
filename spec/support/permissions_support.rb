def login_as user
  visit new_user_session_path

  fill_in_fields :user, email: user.email, password: 'password'
  click_button 'Sign in'
end
