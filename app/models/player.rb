class Player < ApplicationRecord
  has_many :movie_stills
  has_many :votes
end
