#!/usr/bin/env ruby
require File.expand_path('../../lib/crawler', __FILE__)

puts MovieInfo.dvd_rank
puts MovieInfo.us_weekend
puts MovieInfo.taipei_weekend
puts MovieInfo.movies('LATEST') # 'first_round','second_round
puts MovieInfo.movies('FIRST_ROUND')
puts MovieInfo.movies('SECOND_ROUND')
