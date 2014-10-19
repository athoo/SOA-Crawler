#!/usr/bin/env ruby

require '../lib/crawler'

puts NiceSchedule.schedules.to_yaml if ARGV.empty?
