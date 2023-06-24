require 'rails_helper'

RSpec.feature 'Users can view exercises', type: :feature do
  let!(:exercise1) { FactoryBot.create(:exercise) }
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, admin: true) }

  scenario 'when not logged in' do
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

  scenario 'when logged in as a regular user' do
    login_as(user)

    visit '/'

    expect(page).to have_content exercise1.name
    expect(page).to have_content exercise1.description.truncate_words(30, omission: '...')
    expect(page).to_not have_link 'Create Exercise'

    click_link exercise1.name

    expect(page).to have_content exercise1.name
    expect(page).to have_content exercise1.description
    expect(page).to have_content exercise1.tests

    expect(page).to have_link 'Attempt'
    expect(page).to have_link 'Edit'
  end

  scenario 'when logged in as an admin ' do
    login_as(admin)

    visit '/'

    expect(page).to have_content exercise1.name
    expect(page).to have_content exercise1.description.truncate_words(30, omission: '...')
    expect(page).to have_link 'Create Exercise'

    click_link exercise1.name

    expect(page).to have_content exercise1.name
    expect(page).to have_content exercise1.description
    expect(page).to have_content exercise1.tests

    expect(page).to have_link 'Attempt'
    expect(page).to have_link 'Edit'
  end
end
