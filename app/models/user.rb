class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable

  has_one_attached :avatar
  has_person_name

  # Things from the Jumpstart Rails template which I don't need right now
  # has_noticed_notifications
  # has_many :notifications, as: :recipient, dependent: :destroy

  has_many :iterations
end
