require 'nokogiri'
require 'open-uri'
require 'yaml'
require 'webrick/httputils'

module TravelSchedule
  # Construct recommended traveling plan from Niceday
  class NiceSchedule
    NICEDAY_URL = 'http://plan.niceday.tw/'

    # example for spot
    NICESPOT_URL = 'http://plan.niceday.tw/trip/searchObject/ZoneName/新竹縣'

    # let the user input which place to check
    def self.name
      puts 'please input the name of certain county(example:新竹縣)'
      place_name = gets.chomp
      url = NICESPOT_URL + place_name
      url
    end

    # parse the spot and get the url
    def self.spot
      # document = name
      NICESPOT_URL.force_encoding('binary')
      doc = WEBrick::HTTPUtils.escape(NICESPOT_URL)
      open_url = Nokogiri::HTML(open(doc))
      open_url
      # titles = get_titles(document)
      # title
    end

    def self.schedules
      document = open_html
      titles = get_titles(document)
      days = get_days(document)
      places = get_places(document)
      links = get_links(document)
      mix(titles, days, places, links)
    end

    def self.open_html
      Nokogiri::HTML(open(NICEDAY_URL))
    end

    def self.get_titles(doc)
      titles = doc.xpath("//div[@class = 'title']//div[@class = 'text']")
      titles.map(&:text)
    end

    def self.get_days(doc)
      days = doc.xpath("//div[@class = 'info']/div[1]")
      days.map { |day| day.text.split(': ')[1] }
    end

    def self.get_places(doc)
      places = doc.xpath("//div[@class = 'info']/div[2]")
      places.map { |place| place.text.gsub(/\s/, '') }
    end

    def self.get_links(doc)
      links = doc.xpath("//div[@class = 'stats']/a/@href")
      links.map { |link| 'http://plan.niceday.tw' + link.text }
    end

    def self.to_yaml
      schedules.to_yaml
    end

    def self.mix(t, d, p, l)
      informations = t.each_with_index.map do |_, index|
        { 'title' => t[index], 'day' => d[index], 'route' => p[index], \
          'link' => l[index] }
      end
      informations
    end
  end
end
