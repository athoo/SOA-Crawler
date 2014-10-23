#!/usr/bin/env ruby
require File.expand_path('../../lib/crawler', __FILE__)

puts MovieInfo.movie_review(ARGV[0] || '')
