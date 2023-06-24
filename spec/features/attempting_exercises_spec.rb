require 'rails_helper'

RSpec.feature 'Users can attempt exercises', type: :feature do
  let!(:exercise1) { FactoryBot.create(:exercise) }
  let(:user) { FactoryBot.create(:user) }

  scenario 'only if logged in' do
    visit "/exercises/#{exercise1.name.parameterize}/iterations/new"

    expect(page).to have_current_path('/users/sign_in')
  end
end
