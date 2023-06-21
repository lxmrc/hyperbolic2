module DockerApi
  class << self
    def create(exercise: nil, user:, image: "alpine", tty: true)
      container = Docker::Container.create("Image" => image, "Tty" => tty)
      return false unless container.present?

      Container.create(exercise: exercise, user: user, image: image, docker_id: container.id)
    end
  end
end
