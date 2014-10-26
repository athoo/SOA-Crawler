$:.push File.expand_path("../lib", __FILE__)
require 'codebadges/version'
Gem::Specification.new do |s|
  s.name = 'movie_crawler'
  s.version = MovieCrawler::VERSION
  s.executables << 'app'
  s.date = '2014-10-25'
  s.summary = 'Grab the movies information from the atmovies.com'
  s.description = 'Grab the movies information from the atmovies.com'
  s.authors = ['Lee Chen', 'Chen Hung Tu', 'David Yang']
  s.email = 'chung1350@hotmail.com'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.homepage = 'https://github.com/ChenLiZhan/SOA-Crawler'
  s.license = 'MIT'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'minitest-rg'
  s.add_runtime_dependency 'nokogiri', '>= 1.6.2' # v.1.6.2 has documented problems
  s.add_runtime_dependency 'iconv'
end
