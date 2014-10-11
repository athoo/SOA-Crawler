#!/usr/bin/env ruby

require './crawler'
require 'yaml'

plan = TravelSchedule::NiceSchedule.schedules
puts plan.to_yaml
