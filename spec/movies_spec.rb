require 'minitest/autorun'
require File.expand_path('../../lib/crawler', __FILE__)

LATEST = 'http://www.atmovies.com.tw/movie/movie_new.html'
SECOND_ROUND = 'http://www.atmovies.com.tw/movie/movie_now2-1.html'
TRAILER_URL = 'http://app.atmovies.com.tw/movie/movie.cfm?action=trailer&film_id='

# generate a random number to test either latest or second_round
rand < 0.5 ? url = LATEST : url = SECOND_ROUND
sample = MovieInfo.movies_parser(url)

describe 'movies_parser should involve' do

  it 'must be non-empty' do
    sample.wont_be_empty
  end

  sample.each do |each_head|
    it 'title must be string' do
      each_head['title'].must_be_instance_of String
    end

    it 'story must be string' do
      each_head['story'].must_be_instance_of String
    end

    it 'date must match the format' do
      each_head['date'].must_match %r{\d+/\d+/\d+}
    end

    it 'runtime must be either empty or digit numbers' do
      each_head['runtime(minutes)'].must_match(/\A|\d+/)
    end

    it 'trailer link must accessible' do
      each_head['trailer'].must_include TRAILER_URL
    end
  end
end
