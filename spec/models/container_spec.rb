require "rails_helper"

RSpec.describe Container, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:container) { DockerApi.create(user: user) }

  let(:test_results) do
    [{ "name" => "test_it_says_hello_world", "passed" => true }]
  end

  describe "#run_exercise" do
    before do
      container.start
    end

    it "executes the test command on the container" do
      expect(container.container)
        .to receive(:exec)
        .with(%w[ruby /hyperbolic/test.rb --verbose])
        .and_call_original

      container.run_exercise
    end
  end

  describe "#prepare!" do
    context "container has exercise" do
      let(:exercise) { FactoryBot.create(:exercise) }
      let(:container) { DockerApi.create(user: user, exercise: exercise) }

      let(:test_preamble) do
        <<~RUBY
          require 'minitest/autorun'
          require 'minitest/reporters'
          require 'minitest/reporters/json_reporter'
          Minitest::Reporters.use! Minitest::Reporters::JsonReporter.new

          require_relative "exercise"
        RUBY
      end

      let(:tests_with_preamble) { test_preamble + "\n" + exercise.tests }

      it "calls #store_file with the correct arguments" do
        expect(container.container)
          .to receive(:store_file)
          .with("/hyperbolic/test.rb", tests_with_preamble)

        container.prepare!
      end

      it "returns true" do
        expect(container.prepare!).to eq(true)
      end
    end

    context "container has no exercise" do
      it "does not call #store_file with the correct arguments" do
        expect(container.container)
          .to_not receive(:store_file)

        container.prepare!
      end

      it "returns false" do
        expect(container.prepare!).to eq(false)
      end
    end
  end
end
