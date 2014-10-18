require 'minitest/autorun'
require 'minitest/rg'
require '../lib/crawler'

describe "All the schedule" do

  before do
    @sample = TravelSchedule::NiceSchedule.to_yaml
  end

  it 'must be non-empty' do
    @sample.wont_be_empty
  end

  it 'size must equal to 6' do
    @sample.size.must_equal 6
  end

  @sample.map do |each_sche|
    it 'title must be string' do
      each_sche['title'].must_be_instance_of String
    end

    it 'day must be Numeric' do
      each_sche['day'].must be kind of Numeric
    end

    it 'day no more than 5' do
      each_sche['day'].wont_be:>, 5
    end

    it 'route must include origin and destination' do
      each_sche['route'].must_include "起點"
      each_sche['route'].must_include "終點"
    end

    #it 'link must respond to html open' do
    #  each_sche['link'].must_respond_to Nokogiri::HTML.:open
    #end

end
