require "rails_helper"

RSpec.feature "Editing exercises", type: :feature do
  let!(:exercise) { FactoryBot.create(:exercise) }
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, admin: true) }

  scenario "Redirect if not logged in" do
    visit edit_exercise_path(exercise)

    expect(page).to have_current_path("/")
  end

  scenario "Redirect if logged in as normal user" do
    login_as(user)

    visit edit_exercise_path(exercise)

    expect(page).to have_current_path("/")
  end

  scenario "Admins can edit exercises" do
    login_as(admin)

    visit edit_exercise_path(exercise)

    expect(page).to have_text("Edit #{exercise.name}")
    expect(page).to have_field("Name")
    expect(page).to have_field("Description")
    expect(page).to have_field("Tests")

    expect(page).to have_button("Save")
    expect(page).to have_link("Delete")

    fill_in "Name", with: "Updated exercise"
    fill_in "Description", with: "Do the Bartman."
    fill_in "Tests", with: "# Tests go here"

    click_on "Save"

    expect(page).to have_text "Exercise was successfully updated."
    expect(page).to have_text "Updated exercise"
    expect(page).to have_text "Do the Bartman."
    expect(page).to have_text "# Tests go here"

    expect(page).to have_link "Back to exercises"

    expect(page).to have_link "Attempt"
    expect(page).to have_link "Edit"

    click_on "Back to exercises"

    expect(page).to have_text "Updated exercise"
    expect(page).to have_text "Do the Bartman."
  end

  scenario "Admins can delete exercises", js: true do
    login_as(admin)

    visit edit_exercise_path(exercise)

    accept_confirm do
      click_on "Delete"
    end

    expect(page).to have_text "Exercise was successfully destroyed."

    expect(page).to_not have_text exercise.name
    expect(page).to_not have_text exercise.description.truncate_words(30, omission: "...")
  end
end
