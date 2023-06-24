require 'rails_helper'

RSpec.feature "Users can log in", type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  scenario 'with valid credentials' do
    visit '/'
    click_link 'Log In'
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end
end
