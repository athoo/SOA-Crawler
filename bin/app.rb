#!/usr/bin/env ruby

require '../lib/crawler'

# puts TravelSchedule::NiceSchedule.to_yaml if ARGV.empty?

# puts NiceSchedule.new.to_yaml if ARGV.empty?
puts NiceSchedule.schedules.to_yaml if ARGV.empty?

# puts NiceSpot.spot("新竹縣")
# puts NiceSpot

# puts TravelSchedule::NiceSchedule.name
# puts TravelSchedule::NiceSchedule.spot
