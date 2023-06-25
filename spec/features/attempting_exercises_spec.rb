# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Attempting exercises", type: :feature do
  let!(:exercise) { FactoryBot.create(:exercise, tests: tests) }

  let(:tests) do
    <<~RUBY
      require 'minitest/autorun'
      require 'minitest/reporters'
      require 'minitest/reporters/json_reporter'
      Minitest::Reporters.use! Minitest::Reporters::JsonReporter.new

      require_relative "exercise"

      class HelloWorldTest < Minitest::Test
        def test_it_says_hello_world
          assert_equal "Hello, world!", HelloWorld.hello
        end
      end
    RUBY
  end

  let(:user) { FactoryBot.create(:user) }

  let(:failed_attempt) do
    <<~RUBY
      class HelloWorld
        def self.hello
         "hi universe"
        end
      end
    RUBY
  end

  let(:successful_attempt) do
    <<~RUBY
      class HelloWorld
        def self.hello
         "Hello, world!"
        end
      end
    RUBY
  end

  scenario "Redirect if not logged in" do
    visit "/exercises/#{exercise.name.parameterize}/iterations/new"

    expect(page).to have_current_path("/users/sign_in")
  end

  scenario "Show the attempt page and create a container" do
    login_as(user)

    expect { visit "/exercises/#{exercise.name.parameterize}/iterations/new" }.to change { Container.count }.by(1)

    expect(page).to have_link("Back to #{exercise.name}")
    expect(page).to have_css("textarea#iteration_code")

    expect(page).to have_text("class HelloWorldTest < Minitest::Test")
    expect(page).to have_text("def test_it_says_hello_world")
    expect(page).to have_text("assert_equal \"Hello, world!\", HelloWorld.hello")
    expect(page).to have_text("end")

    expect(page).to have_button("Run")
    expect(page).to have_button("Save")
  end

  scenario "Attempt the exercise unsuccessfully", js: true do
    login_as(user)

    visit "/exercises/#{exercise.name.parameterize}/iterations/new"

    fill_in "iteration_code", with: failed_attempt
    click_on "Run"

    expect(page).to have_css("ul#test-results li.list-group-item.list-group-item-danger",
                             text: "test_it_says_hello_world")
  end

  scenario "Attempt the exercise successfully", js: true do
    login_as(user)

    visit "/exercises/#{exercise.name.parameterize}/iterations/new"

    fill_in "iteration_code", with: successful_attempt
    click_on "Run"

    expect(page).to have_css("ul#test-results li.list-group-item.list-group-item-success",
                             text: "test_it_says_hello_world")
  end
end
