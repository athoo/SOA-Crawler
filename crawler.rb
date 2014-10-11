require 'nokogiri'
require 'open-uri'

module TravelSchedule
  class NiceSchedule
    NICEDAY_URL = 'http://plan.niceday.tw/'

    def self.get_schedule
      doc = Nokogiri::HTML(open(NICEDAY_URL))

      titles = doc.xpath("//div[@class = 'title']//div[@class = 'text']")
      titles_array = titles.map { |title| title.text }

      days = doc.xpath("//div[@class = 'info']/div[1]")
      days_array = days.map { |day| day.text.split(': ')[1] }

      schedules = doc.xpath("//div[@class = 'info']/div[2]")
      schedule_array = schedules.map { |schedule| schedule.text.gsub(/\s/, '') }

      informations = titles_array.each_with_index.map do |_, index|
        [titles_array[index], [days_array[index], schedule_array[index]]]
      end

      Hash[informations]
    end
  end
end

p TravelSchedule::NiceSchedule.get_schedule
