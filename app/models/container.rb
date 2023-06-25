class Container < ApplicationRecord
  belongs_to :user
  belongs_to :exercise, optional: true

  validates_presence_of :docker_id

  extend FriendlyId
  friendly_id :token, use: :slugged

  after_create :update_name
  before_destroy :remove_container

  delegate :start,
           :stop,
           :info,
           :store_file, to: :container

  def prepare!
    return false unless exercise.present?

    @container.store_file("/hyperbolic/test.rb", exercise.tests)
    @container.start
    true
  end

  def run_exercise
    @container.exec(%w[ruby /hyperbolic/test.rb --verbose])[0][0]
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
