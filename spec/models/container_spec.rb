require "rails_helper"

RSpec.describe Container, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:container) { DockerApi.create(user: user, exercise: exercise) }

  describe "#run_exercise" do
    let(:tests) { File.read("spec/fixtures/exercises/fizzbuzz_test.rb") }
    let(:exercise) { FactoryBot.create(:exercise, name: "FizzBuzz", tests: tests) }

    xcontext "container not found" do
    end

    xcontext "container not started" do
    end

    xcontext "container started but not prepared" do
      before do
        container.start
      end
    end

    context "container started and prepared" do
      before do
        container.start
        container.prepare!
      end

      it "executes the test command on the container" do
        expect(container)
          .to receive(:exec)
          .with(%w[ruby /hyperbolic/test.rb --verbose])
          .and_call_original

        container.run_exercise("# Code goes here")
      end

      context "all tests pass" do
        let(:code) do
          <<~RUBY
            def fizzbuzz(n)
              return "FizzBuzz" if n % 15 == 0
              return "Buzz" if n % 5 == 0
              return "Fizz" if n % 3 == 0
              n.to_s
            end
          RUBY
        end

        let(:test_results) do
          [
            { "name" => "test_returns_number_as_string_when_not_divisible_by_3_or_5", "passed" => true },
            { "name" => "test_returns_fizz_when_divisible_by_3", "passed" => true },
            { "name" => "test_returns_buzz_when_divisible_by_5", "passed" => true },
            { "name" => "test_returns_fizzbuzz_when_divisible_by_3_and_5", "passed" => true }
          ]
        end

        it "returns a hash representation of the test results" do
          expect(container.run_exercise(code)).to match_array(test_results)
        end
      end

      context "some tests pass" do
        let(:code) do
          <<~RUBY
            def fizzbuzz(n)
              return "Buzz" if n % 5 == 0
              return "Fizz" if n % 3 == 0
              n.to_s
            end
          RUBY
        end

        let(:test_results) do
          [
            { "name" => "test_returns_number_as_string_when_not_divisible_by_3_or_5", "passed" => true },
            { "name" => "test_returns_fizz_when_divisible_by_3", "passed" => true },
            { "name" => "test_returns_buzz_when_divisible_by_5", "passed" => true },
            {
              "name" => "test_returns_fizzbuzz_when_divisible_by_3_and_5",
              "passed" => false,
              "failures" => ["Expected: \"FizzBuzz\"\n  Actual: \"Buzz\""]
            }
          ]
        end

        it "returns a hash representation of the test results" do
          expect(container.run_exercise(code)).to match_array(test_results)
        end
      end

      xcontext "all tests fail" do
      end

      xcontext "exercise file not found" do
      end

      xcontext "running tests raises exception" do
      end
    end
  end

  describe "#prepare!" do
    context "container has exercise" do
      let(:exercise) { FactoryBot.create(:exercise) }

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
        expect(container)
          .to receive(:store_file)
          .with("/hyperbolic/test.rb", tests_with_preamble)

        container.prepare!
      end

      it "returns true" do
        expect(container.prepare!).to eq(true)
      end
    end

    context "container has no exercise" do
      let(:exercise) { nil }

      it "does not call #store_file with the correct arguments" do
        expect(container)
          .to_not receive(:store_file)

        container.prepare!
      end

      it "returns false" do
        expect(container.prepare!).to eq(false)
      end
    end
  end
end
