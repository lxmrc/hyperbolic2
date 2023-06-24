require 'rails_helper'

RSpec.feature 'Users can view exercises', type: :feature do
  let!(:exercise1) { FactoryBot.create(:exercise) }

  scenario 'when not authenticated' do
    visit '/'

    expect(page).to have_content exercise1.name
    expect(page).to have_content exercise1.description.truncate_words(30, omission: '...')
    expect(page).to_not have_link 'Create Exercise'

    click_link exercise1.name

    expect(page).to have_content exercise1.name
    expect(page).to have_content exercise1.description
    expect(page).to have_content exercise1.tests

    expect(page).to_not have_link 'Attempt'
    expect(page).to_not have_link 'Edit'
  end
end
