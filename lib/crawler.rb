require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'webrick/httputils'

class MovieInfo

  ATMOVIES_URL = 'http://www.atmovies.com.tw/movie/movie_new.html'
  MOVIE_BASE_URL = 'http://www.atmovies.com.tw/movie/'

  def self.movie_review(code = '')
    code.empty? ? to_yaml(movies) : movie(code)
  end

  def self.movies
    document = open_html(ATMOVIES_URL)
    titles = get_titles(document)
    stories = get_story(document)
    dates = get_dates(document)
    codes = get_codes(document)
    mix(titles, stories, dates, codes)
  end

  def self.movie(code)
    open_html(MOVIE_BASE_URL + code + '/')
  end

  # open the destination url
  def self.open_html(url)
    Nokogiri::HTML(open(url))
  end

  # get the movie name
  def self.get_titles(doc)
    titles = doc.xpath("//div[@class = 'title']/a")
    titles.map { |title| title.text.gsub(/[\t\n\r]/, '') }
  end

  # get the storyline of movie
  def self.get_story(doc)
    storylines = doc.xpath("//div[@class = 'story']")
    storylines.map { |story| story.text }
  end

  # get the release dates
  def self.get_dates(doc)
    places = doc.xpath("//div[@class = 'date']/b")
    places.map { |place| place.text.gsub(/\s/, '') }
  end

  # get the code of movies
  def self.get_codes(doc)
    codes = doc.xpath("//div[@class = 'title']/a/@href")
    codes.map { |code| code.value.split('/')[2] }
  end

  # build the hash for yaml output
  def self.mix(t, s, d, c)
    informations = t.each_with_index.map do |_, index|
      { 'title' => t[index], 'code' => c[index], 'story' => s[index], \
        'date' => d[index] }
    end
    informations
  end

  # convert the schedules to yaml format
  def self.to_yaml(mix)
    mix.to_yaml
  end
end
