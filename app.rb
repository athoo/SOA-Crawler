#!/usr/bin/env ruby

require './crawler'

plan = TravelSchedule::NiceSchedule.schedules

puts plan
