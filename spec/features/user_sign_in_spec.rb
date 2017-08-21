require 'spec_helper'

feature "user sign in" do
  given(:password) { 'test' }
  given(:user) { Fabricate(:user, password: password) }

  scenario "with existing username and valid password" do
    sign_in_user(user, password)
    expect(page).to have_content(user.full_name)
  end
end
