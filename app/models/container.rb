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
           :store_file,
           :exec,
           :delete,
           :info, to: :container

  MINITEST_PREAMBLE = <<~RUBY
    require 'minitest/autorun'
    require 'minitest/reporters'
    require 'minitest/reporters/json_reporter'
    Minitest::Reporters.use! Minitest::Reporters::JsonReporter.new

    require_relative "exercise"
  RUBY

  def prepare!
    return false unless exercise.present?

    tests = MINITEST_PREAMBLE + "\n" + exercise.tests

    store_file("/hyperbolic/test.rb", tests)
    start
    true
  end

  def run_exercise(code)
    store_file("/hyperbolic/exercise.rb", code)

    output = exec(%w[ruby /hyperbolic/test.rb --verbose])
    results, errors = output

    if results.any?
      results = JSON.parse(results.first).map(&:symbolize_keys)
      success = true
    else
      success = false
    end

    OpenStruct.new({ success: success, results: results, errors: errors })
  end

  def container
    @container = Docker::Container.get(docker_id)
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

  def remove_container
    delete(force: true)
  end
end
