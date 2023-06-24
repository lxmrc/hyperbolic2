require 'rails_helper'

RSpec.feature 'Logged-in users can log out', js: true do
  let!(:user) { FactoryBot.create(:user) }

  before do
    login_as(user)
  end

  scenario do
    visit '/'
    click_on 'navbar-dropdown'
    click_button 'Log Out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
