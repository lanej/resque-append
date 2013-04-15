Bundler.require(:test)

require File.expand_path("../../lib/resque/append", __FILE__)

Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each{|f| require(f)}

RSpec.configure do |config|
  config.order = :random
end
