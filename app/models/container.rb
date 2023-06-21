class Container < ApplicationRecord
  validates_presence_of :docker_id

  after_create :update_name

  delegate :start, :stop, :info, to: :container

  def container
    @container ||= Docker::Container.get(docker_id)
  end

  def status
    info.dig("State", "Status")
  end

  def running?
    info.dig("State", "Running")
  end

  private

  def update_name
    update(name: info["Name"][1..-1])
  end
end
