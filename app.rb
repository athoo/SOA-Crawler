#!/usr/bin/env ruby

require './crawler'

puts TravelSchedule::NiceSchedule.to_yaml if ARGV.empty?

# puts TravelSchedule::NiceSchedule.name
# puts TravelSchedule::NiceSchedule.spot
