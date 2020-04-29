class ResultsGenerator
  def initialize(theme_author = nil)
    @theme_author = theme_author
  end

  def call
    erb_to_html
  end

  private

  def erb_to_html
    bind = binding
    bind.local_variable_set(:stills, MovieStill.recent)
    bind.local_variable_set(:votes, Vote.recent)
    bind.local_variable_set(:theme_author, @theme_author)
    erb_file = 'app/views/results.html.erb'
    result = ERB.new(File.read(erb_file), nil, '-').result(bind)

    File.open("storage/html/#{Date.current.strftime('%Y-%m-%d')}.html", 'w') do |f|
      f.write(result.gsub(/\n{2, }/, "\n"))
    end
  end
end
