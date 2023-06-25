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
end
