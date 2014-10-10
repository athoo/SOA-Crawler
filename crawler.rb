require 'nokogiri'
require 'open-uri'

module TravelSchedule
  class NiceSchedule
    NICEDAY_URL = 'http://plan.niceday.tw/'

    def self.get_schedule
      doc = Nokogiri::HTML(open(NICEDAY_URL))

      titles = doc.xpath("//div[@class = 'title']//div[@class = 'text']")
      titles_array = titles.map { |title| title.text }

      infos = doc.xpath("//div[@class = 'info']/div[1]")
      infos_array = infos.map { |info| info.text.split(': ')[1] }

    end
  end
end
