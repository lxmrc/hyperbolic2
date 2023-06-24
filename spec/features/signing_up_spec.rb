# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users can sign up', type: :feature do
  scenario 'when providing valid details' do
    visit '/'
    click_link 'Sign Up'
    fill_in 'Username', with: 'user1'
    fill_in 'Email Address', with: 'user1@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Confirm Password', with: 'password'
    click_button 'Sign up'
    expect(page).to have_content('You have signed up successfully.')
  end
end
