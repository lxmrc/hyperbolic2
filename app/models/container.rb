class Container < ApplicationRecord
  extend FriendlyId
  friendly_id :token, use: :slugged

  belongs_to :user
  belongs_to :exercise, optional: true

  validates_presence_of :docker_id

  after_create :update_name
  before_destroy :remove_container

  delegate :start,
           :stop,
           :info,
           :store_file, to: :container

  def run_tests
    @container.exec(["ruby", "/hyperbolic/test.rb", "--verbose"])[0][0].to_s
  end

  def container
    @container = Docker::Container.get(docker_id)
  end

  def status
    info.dig('State', 'Status')
  end

  def running?
    info.dig('State', 'Running')
  end

  private

  def update_name
    update(name: info['Name'][1..-1])
  end

  def remove_container
    container.delete(force: true)
  end
end
