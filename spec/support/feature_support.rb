def sign_in(user)
  visit sign_in_path
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  within("form") { click_on "Sign In" }
end
