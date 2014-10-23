require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'webrick/httputils'

module MovieInfo
    # open the destination url
    def open_html(url)
      Nokogiri::HTML(open(url))
    end

    # get the movie name
    def get_titles(doc)
      titles = doc.xpath("//div[@class = 'title']/a")
      titles.map{|title| title.text.gsub(/[\t\n]/, '')}
    end

    # get the storyline of movie
    def get_storylines(doc)
      storylines = doc.xpath("//div[@class = 'story']")
      storylines.map { |story| story.text}
    end

    # get the release dates
    def get_dates(doc)
      places = doc.xpath("//div[@class = 'date']/b")
      places.map { |place| place.text.gsub(/\s/, '') }
    end

    # get the link to a deeper knowledge
    def get_links(doc)
      links = doc.xpath("//div[@class = 'stats']/a/@href")
      links.map { |link| 'http://plan.niceday.tw' + link.text }
    end

    def get_downloads(doc)
      downloads = doc.xpath("//div[@class = 'bottom']//div[@class = 'download']")
      downloads.map { |download| download.text.to_i}
      # downloads.map{ |download| }
    end

    # build the hash for yaml output
    def mix(t, d, p, l, dt)
      informations = t.each_with_index.map do |_, index|
        { 'title' => t[index], 'day' => d[index].to_i, 'route' => p[index], \
          'link' => l[index], 'download_times' => dt[index] }
      end
      informations
    end

    # convert the schedules to yaml format
    def to_yaml(mix)
      mix.to_yaml
    end
end

# Construct recommended traveling plan from Niceday
class NiceSchedule
  extend TravelSchedule

  NICEDAY_URL = 'http://plan.niceday.tw/'

  # get data for schedules check
  def self.schedules
    document = open_html(NICEDAY_URL)
    titles = get_titles(document)
    days = get_days(document)
    places = get_places(document)
    links = get_links(document)
    download_times = get_downloads(document)
    out = mix(titles, days, places, links, download_times)
  end
  to_yaml(self.schedules)
end

class NiceSpot
  extend TravelSchedule
  # example for spot
  NICESPOT_URL = 'http://plan.niceday.tw/trip/searchObject/ZoneName/'

  # parse the spot and get the url
  def self.spot(place_name)
    url = NICESPOT_URL + place_name
    # transform the asc-ii url to binary one which is possible for nokogiri to manipulate
    url.force_encoding('binary')
    # Escapes HTTP reserved and unwise characters in str
    doc = WEBrick::HTTPUtils.escape(url)
    document = open_html(doc)
    titles = get_titles(document)

  end
end
