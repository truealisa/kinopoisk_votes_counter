require 'open-uri'

class StillsScraper
  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  def initialize(post_number)
    @start_post = post_number
  end

  def collect!
    html = open(start_url)

    loop do
      doc = Nokogiri::HTML(html)
      collect_from_page!(doc)
      next_page = doc.xpath('//a[starts-with(@title, "Следующая страница")]')
      break if next_page.empty?

      html = open(base_url + next_page.first['href'])
    end
  end

  private

  def collect_from_page!(doc)
    @posts = doc.xpath('//div[starts-with(@id, "post_message")]')
    remove_old
    remove_quotes
    remove_without_images
    save_data!
  end

  def save_data!
    @posts.each do |post|
      titles = post.content.split(/$/).select { |line| line.match?(/[\wа-яА-Яa-zA-Z]/) }.map(&:strip!)
      images = post.search('img').map { |img| img['src'] }
      player_name = post.parent.parent.at('td div a').content
      player = Player.find_or_create_by(name: player_name)
      titles.each_with_index do |title, i|
        MovieStill.create!(name: title, link: images[i], player: player)
      end
    end
  end

  def remove_old
    @posts = @posts.reject { |post| post['id'].gsub(/\D+/, '').to_i < @start_post.to_i }
  end

  def remove_without_images
    @posts = @posts.reject do |post|
      images = post.search('img')
      images = images.reject { |img| img['class'] == 'inlineimg' }
      images.empty?
    end
  end

  def remove_quotes
    @posts = @posts.reject { |post| post.at('div:contains("Цитата")').present? }
  end

  def start_url
    base_url + thread_uri + @start_post
  end

  def thread_uri
    'showthread.php?p='
  end

  def base_url
    'https://forumkinopoisk.ru/'
  end
end
