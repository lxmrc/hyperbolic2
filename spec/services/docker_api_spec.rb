require "rails_helper"

RSpec.describe DockerApi do
  describe ".create" do
    let(:exercise) { FactoryBot.create(:exercise) }
    let(:user) { FactoryBot.create(:user) }
    let(:image) { "ghcr.io/lxmrc/minitest-hyperbolic:latest" }

    subject(:docker_api_create) do
      DockerApi.create(user: user, exercise: exercise, image: image)
    end

    context "when container is created successfully" do
      it "calls Docker::Container.create with the correct arguments" do
        expect(Docker::Container).to receive(:create).with("Image" => image, "Tty" => true)
        docker_api_create
      end

      it "creates a Docker container" do
        expect { docker_api_create }.to change { Docker::Container.all(all: true).count }.by(1)
      end

      it "creates a container record" do
        expect { docker_api_create }.to change { Container.count }.by(1)

        container = Container.last

        expect(container.exercise).to eq(exercise)
        expect(container.user).to eq(user)
        expect(container.image).to eq(image)
        expect(container.docker_id).to_not be_nil
        expect(container.token).to_not be_nil
      end

      it "returns a Container" do
        expect(DockerApi.create(user: user, exercise: exercise, image: image)).to be_a(Container)
      end
    end

    context "when container creation fails" do
      before do
        allow(Docker::Container).to receive(:create).and_return(nil)
      end

      it "does not create a new Docker container" do
        expect { docker_api_create }.to change { Docker::Container.all(all: true).count }.by(0)
      end

      it "does not create a container record" do
        expect { docker_api_create }.to change { Container.count }.by(0)
      end

      it "returns false" do
        expect(docker_api_create).to be(false)
      end
    end
  end
end
