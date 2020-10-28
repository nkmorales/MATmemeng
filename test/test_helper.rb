Dir["#{Dir.pwd}/lib/**/*.rb"].each { |f| require(f) }
require "minitest/autorun"
