class Exercise < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :iterations
end
