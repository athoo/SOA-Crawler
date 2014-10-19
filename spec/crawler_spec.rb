require 'minitest/autorun'
require 'minitest/rg'
require '../lib/crawler'

sample = NiceSchedule.schedules

describe 'All the schedule' do

  it 'must be non-empty' do
    sample.wont_be_empty
  end

  it 'size must equal to 6' do
    sample.size.must_equal 6
  end

  sample.each do |each_sche|
    it 'title must be string' do
      each_sche['title'].must_be_instance_of String
    end

    it 'day must be Numeric' do
      each_sche['day'].must_be_kind_of Numeric
    end

    it 'day no more than 5' do
      each_sche['day'].wont_be :>, 5
    end

    it 'route must include origin and destination' do
      each_sche['route'].must_include '起點'
      each_sche['route'].must_include '終點'
    end
  end
end
