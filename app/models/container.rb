class Container < ApplicationRecord
  validates_presence_of :docker_id

  after_create :update_name

  delegate :start, :info, to: :docker_container

  def docker_container
    @docker_container ||= Docker::Container.get(docker_id)
  end

  def update_name
    update(name: info["Name"][1..-1])
  end
end
