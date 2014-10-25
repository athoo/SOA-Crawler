#!/usr/bin/env ruby
require File.expand_path('../../lib/crawler', __FILE__)

# puts MovieInfo.movie_review(ARGV[0] || '')

# puts MovieInfo.dvd_rank
# puts MovieInfo.us_weekend
# puts MovieInfo.taipei_weekend
# puts MovieInfo.movie_review(code)

puts MovieInfo.movies('LATEST') # 'first_round','second_round
