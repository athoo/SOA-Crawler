require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'iconv'
require 'webrick/httputils'

# get the info from atmovies
class MovieInfo
  ATMOVIES_URL = 'http://www.atmovies.com.tw/movie/movie_new.html'
  MOVIE_BASE_URL = 'http://www.atmovies.com.tw/movie/'
  WHOLE_MOVIEWS_TITLES = "//div[@class = 'title']/a"
  WHOLE_MOVIEWS_STORIES = "//div[@class = 'story']"
  WHOLE_MOVIEWS_DATES = "//div[@class = 'date']/b"
  WHOLE_MOVIEWS_CODES = "//div[@class = 'title']/a/@href"
  REFLECTION_BASE = 'http://app.atmovies.com.tw/tool/good.cfm?type=film'
  REFLECTION_FS = '&fs=2'
  REFLECTION_CLASS = "//div[@class = 'act01']"
  REFLECTION_SATITLE = '&satitle='
  REFLECTION_SAID = '&said='
  REFLECTION_NAME = "//span[@class = 'at21b']"
  TRAILER_URL = 'http://app.atmovies.com.tw/movie/movie.cfm?action=trailer&film_id='

  def self.movie_review(code = '')
    code.empty? ? to_yaml(movies) : movie(code)
  end

  def self.movies
    document = open_html(ATMOVIES_URL)
    titles = get_titles(document)
    stories = get_stories(document)
    dates = get_dates(document)
    times = get_runtime(document)
    trailers = get_trailer(document)
    mix(titles, stories, dates, times, trailers)
  end

  def self.movie(code)
    document = open_html(MOVIE_BASE_URL + code + '/')
    info_said = REFLECTION_SAID + code
    name = get_one_movie_name(document)
    info_satitle = encode_zh(name)
    info_uri = REFLECTION_BASE + info_said + info_satitle + REFLECTION_FS
    informations = open_html(info_uri)
    reflection = get_reflection(informations)
    { name: name, like: reflection[0], unlike: reflection[1] }
  end

  def self.encode_zh(text)
    REFLECTION_SATITLE + URI.encode(Iconv.new('big5', 'utf-8').iconv(text)).to_s
  end

  def self.get_one_movie_name(doc)
    name = doc.xpath(REFLECTION_NAME).text
    name.gsub!(/[\t\r\n]/, '')
  end

  def self.get_reflection(doc)
    doc.xpath(REFLECTION_CLASS).text.gsub!(/[\t\r\n]/, '').split
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
    titles = doc.xpath(WHOLE_MOVIEWS_TITLES)
    titles.map { |title| title.text.gsub(/[\t\n\r]/, '') }
  end

  # get the storyline of movie
  def self.get_stories(doc)
    storylines = doc.xpath(WHOLE_MOVIEWS_STORIES)
    storylines.map { |story| story.text }
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

  def self.split_day_and_time(doc)
    gap = "\n\t\t\t\t\s\s\s\s\t"
    days_times = doc.xpath(WHOLE_MOVIEWS_DATES)
    days_times.map { |d_t| d_t.text.split(gap) }
  end

  # get the code of movies
  def self.get_codes(doc)
    codes = doc.xpath(WHOLE_MOVIEWS_CODES)
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
