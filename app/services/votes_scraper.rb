require 'open-uri'

class VotesScraper
  def collect!
    File.open('votes.txt', 'r') do |file|
      player = nil
      file.each_line do |line|
        line = line.strip
        next if line.empty?

        if Player.find_by(name: line)
          player = Player.find_by(name: line)
          next
        end
        movie = line[0...-1].strip
        still = MovieStill.recent.find_by(name: movie)
        points = line[-1]
        Vote.create!(player: player, points: points, movie_still: still)
      end
    end
  end
end
