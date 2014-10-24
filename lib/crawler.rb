require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'iconv'
require 'webrick/httputils'

class MovieInfo
  LATEST = 'http://www.atmovies.com.tw/movie/movie_new.html'
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
  FIRST_ROUND = 'http://www.atmovies.com.tw/movie/movie_now-1.html'
  SECOND_ROUND = 'http://www.atmovies.com.tw/movie/movie_now2-1.html'
  ATMOVIES_MAIN_URL = 'http://www.atmovies.com.tw/home/movie_homepage.html'

  # add three rank parser
  def self.us_weekend
    document = open_html(ATMOVIES_MAIN_URL)
    get_table(document, '1')
  end

  def self.taipei_weekend
    document = open_html(ATMOVIES_MAIN_URL)
    get_table(document, '2')
  end

  def self.dvd_rank
    document = open_html(ATMOVIES_MAIN_URL)
    get_table(document, '3')
  end

  # parse the ranktable info
  def self.get_table(doc, rankid)
    table = doc.xpath("//*[@id = 'ranklist']/div[" + rankid + ']').text
    table = table.gsub(' : ', ':').gsub(' ', '').split
    table = table.each { |item| item.gsub(/[\t\r\n]/, '') }
    table.pop
    to_yaml(rankmix(table))
  end

  # mix the rank info
  def self.rankmix(t)
    t.each_with_index.map do |_, index|
      {
        index + 1 => t[index].to_s
      }
    end
  end

  # switch to different url accordingly
  def self.movies(category)
    case category.upcase
    when 'LATEST'
      url = LATEST
    when 'FIRST_ROUND'
      url = FIRST_ROUND
    when 'SECOND_ROUND'
      url = SECOND_ROUND
    end
    movies_parser(url)
  end

  # parse the movies acoordingly
  def self.movies_parser(url)
    document = open_html(url)
    titles = get_titles(document)
    stories = get_stories(document)
    dates = get_dates(document)
    codes = get_codes(document)
    result = mix(titles, codes, stories, dates)
    to_yaml(result)
  end
  
  # see the specific movie info
  def self.movie_review(code)
    document = open_html(MOVIE_BASE_URL + code + '/')
    info_said = REFLECTION_SAID + code
    name = get_one_movie_name(document)
    info_satitle = encode_zh(name)
    info_uri = REFLECTION_BASE + info_said + info_satitle + REFLECTION_FS
    informations = open_html(info_uri)
    reflection = get_reflection(informations)
    out = { name: name, like: reflection[0], unlike: reflection[1] }
    to_yaml(out)
  end

  def self.encode_zh(text)
    REFLECTION_SATITLE + URI.encode(Iconv.new('big5', 'utf-8').iconv(text)).to_s
  end

  def self.get_one_movie_name(doc)
    name = doc.xpath("//span[@class = 'at21b']").text
    name.gsub!(/[\t\r\n]/, '')
  end

  def self.get_reflection(doc)
    doc.xpath(REFLECTION_CLASS).text.gsub!(/[\t\r\n]/, '').split
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
    storylines.map(&:text) # { |story| story.text }
  end

  # get the release dates
  def self.get_dates(doc)
    places = doc.xpath(WHOLE_MOVIEWS_DATES)
    places.map { |place| place.text.gsub(/\s/, '') }
  end

  # get the code of movies
  def self.get_codes(doc)
    codes = doc.xpath(WHOLE_MOVIEWS_CODES)
    codes.map { |code| code.value.split('/')[2] }
  end

  # build the hash for yaml output
  def self.mix(t, c, s, d)
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
