require 'nokogiri'
require 'open-uri'
require 'yaml'

# get the info from atmovies
class MovieInfo
  ATMOVIES_URL = 'http://www.atmovies.com.tw/movie/movie_new.html'
  MOVIE_BASE_URL = 'http://www.atmovies.com.tw/movie/'
  TRAILER_URL = 'http://app.atmovies.com.tw/movie/movie.cfm?action=trailer&film_id='

  def self.movie_review(code = '')
    code.empty? ? to_yaml(movies) : movie_details(code)
  end

  def self.movies
    document = open_html(ATMOVIES_URL)
    titles = get_titles(document)
    stories = get_story(document)
    dates = get_dates(document)
    times = get_runtime(document)
    trailers = get_trailer(document)
    mix(titles, stories, dates, times, trailers)
  end

  # get the details of movie
  def self.movie_details(code)
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
    storylines.map(&:text)
  end

  def self.split_day_and_time(doc)
    gap = "\n\t\t\t\t\s\s\s\s\t"
    days_times = doc.xpath("//div[@class = 'date']/b")
    days_times.map { |d_t| d_t.text.split(gap) }
  end

  # get the runtime of movie
  def self.get_runtime(doc)
    days_times = split_day_and_time(doc)
    days_times.map { |d_t| d_t[0].match(/\d+/).to_s }
  end

  # get the release date
  def self.get_dates(doc)
    date_format = '\d+\/\d+\/\d+' # mm/dd/yy
    days_times = split_day_and_time(doc)
    days_times.map { |d_t| d_t[1].match(/#{date_format}/).to_s }
  end

  # get the code of movies
  def self.get_codes(doc)
    codes = doc.xpath("//div[@class = 'title']/a/@href")
    codes.map { |code| code.value.split('/')[2] }
  end

  # get the trailer link of the movies
  def self.get_trailer(doc)
    codes = get_codes(doc)
    codes.map { |trailer| TRAILER_URL + trailer }
  end

  # build the hash for yaml output
  def self.mix(t, s, d, ti, tr)
    informations = t.each_with_index.map do |_, index|
      { 'title' => t[index], 'story' => s[index], \
        'date' => d[index], 'runtime(minutes)' => ti[index].to_i, \
        'trailer' => tr[index] }
    end
    informations
  end

  # convert the schedules to yaml format
  def self.to_yaml(mix)
    mix.to_yaml
  end
end
