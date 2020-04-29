class Vote < ApplicationRecord
  belongs_to :movie_still
  belongs_to :player

  scope :recent, -> { where('created_at > ?', Time.zone.now - 1.day) }
end
