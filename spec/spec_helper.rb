require 'allrecipes'
require 'vcr'
require 'webmock/rspec'
require 'coveralls'
Coveralls.wear!
WebMock.disable_net_connect!(:allow => 'coveralls.io')


VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end


