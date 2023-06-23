module DockerApi
  class << self
    def create(user:, exercise: nil, image: 'ghcr.io/lxmrc/minitest-hyperbolic:latest', tty: true)
      container = Docker::Container.create('Image' => image, 'Tty' => tty)
      return false unless container.present?

      Container.create(exercise: exercise,
                       user: user,
                       image: image,
                       docker_id: container.id,
                       token: SecureRandom.uuid)
    end
  end
end
