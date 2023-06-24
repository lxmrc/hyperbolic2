# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Creating exercises", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, admin: true) }

  scenario "Redirect if not logged in" do
    visit "/exercises/new"

    expect(page).to have_current_path("/")
  end

  scenario "Redirect if logged in as normal user" do
    login_as(user)

    visit "/exercises/new"

    expect(page).to have_current_path("/")
  end

  scenario "Admins can create exercises" do
    login_as(admin)

    visit "/exercises/new"

    expect(page).to have_text("New exercise")
    expect(page).to have_field("Name")
    expect(page).to have_field("Description")
    expect(page).to have_field("Tests")

    expect(page).to have_button("Save")
    expect(page).to have_link("Cancel")

    fill_in "Name", with: "New exercise"
    fill_in "Description", with: "Do the Bartman."
    fill_in "Tests", with: "# Tests go here"

    click_on "Save"

    expect(page).to have_text "Exercise was successfully created."
    expect(page).to have_text "New exercise"
    expect(page).to have_text "Do the Bartman."
    expect(page).to have_text "# Tests go here"

    expect(page).to have_link "Back to exercises"

    expect(page).to have_link "Attempt"
    expect(page).to have_link "Edit"

    click_on "Back to exercises"

    expect(page).to have_text "New exercise"
    expect(page).to have_text "Do the Bartman."
  end
end
