class MovieStill < ApplicationRecord
  belongs_to :player
  has_many :votes

  scope :recent, -> { where('created_at > ?', Time.zone.now - 1.day) }
end
