require 'nokogiri'
require 'open-uri'

module TravelSchedule
  # Construct recommended traveling plan from Niceday
  class NiceSchedule
    NICEDAY_URL = 'http://plan.niceday.tw/'

    def self.schedules
      document = open_html
      titles = get_titles(document)
      days = get_days(document)
      places = get_places(document)
      mix(titles, days, places)
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

    def self.mix(t, d, p)
      informations = t.each_with_index.map do |_, index|
        [t[index], [d[index], p[index]]]
      end
      Hash[informations]
    end
  end
end
