module DockerApi
  class << self
    def create(user:, exercise: nil, image: 'ghcr.io/lxmrc/minitest-hyperbolic:latest')
      container = Docker::Container.create('Image' => image, 'Tty' => true)
      return false unless container.present?

      Container.create(exercise: exercise,
                       user: user,
                       image: image,
                       docker_id: container.id,
                       token: SecureRandom.hex(5))
    end
  end
end
