#!/usr/bin/env ruby

require './crawler'

print TravelSchedule::NiceSchedule.get_schedule
