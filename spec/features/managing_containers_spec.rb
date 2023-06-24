require "rails_helper"

RSpec.feature "Managing containers", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, admin: true) }

  scenario "Redirect if not logged in" do
    visit "/containers"

    expect(page).to have_current_path("/")
  end

  scenario "Redirect if logged in as normal user" do
    login_as(user)

    visit "/containers"

    expect(page).to have_current_path("/")
  end

  scenario "Admins can manage containers" do
    login_as(admin)

    visit "/containers"

    expect(page).to have_button("Spawn Container")

    expect { click_on "Spawn Container" }.to change { Container.count }.by(1)

    container = Container.last

    expect(page).to have_text(container.name)
    expect(page).to have_text(container.token)
    expect(page).to have_text(container.docker_id)
    expect(page).to have_text(container.image)
    expect(page).to have_text(container.status)

    expect(page).to have_button("Start")
    expect(page).to have_button("Stop")
    expect(page).to have_button("Remove")

    click_on "Start"

    expect(container.status).to eq("running")

    click_on "Stop"

    expect(container.status).to eq("exited")

    expect { click_on "Remove" }.to change { Container.count }.by(-1)
  end
end
