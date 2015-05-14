# run with working directory set to ruxed/lib

require 'ruxed-transformer'
require 'ruxed-parameter-detector'
require 'transformers/xdoc/xdoc'

input = File.new(__FILE__).path + '../transformers/xdoc/xdoc.xml'
puts RUXEDParameterDetector.new.detect(input).transform