require 'minitest/autorun'
require 'minitest/rg'
require File.expand_path('../../lib/crawler', __FILE__)

# 1 to 3 means diffent test case related to us, taipei, dvd
rand_rank = rand(1..3)
sample = MovieInfo.get_table(rand_rank.to_s)

describe 'table should involve' do

  it 'must be non-empty' do
    sample.wont_be_empty
  end

  it 'size must be ten' do
    sample.size.must_equal 10
  end

  sample.each do |each_movie|

    it 'each_movie must be non-empty' do
      each_movie.wont_be_empty
    end

    it 'each_key must be string' do
      each_movie.each_value { |key| key.must_be_instance_of String }
    end

    # Hash to_s would be like "{index=>\"movie_name\"}"
    it 'each_key must match the format' do
      each_movie.to_s.must_match %r{\{\d+=>\"\W+\"\}}
    end
  end

end
