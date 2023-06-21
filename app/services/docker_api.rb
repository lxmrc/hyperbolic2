module DockerApi
  class << self
    def create(image: "alpine", tty: true)
      container = Docker::Container.create("Image" => image, "Tty" => tty)
      return false unless container.present?

      Container.create(image: image, docker_id: container.id)
    end
  end
end
