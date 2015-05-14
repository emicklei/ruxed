# run with working directory set to ruxed/lib

require 'ruxed-transformer'
require 'transformers/xdoc/xdoc'

input = '../transformers/xdoc/xdoc.xml'
output = '../transformers/xdoc/xdoc.html'
XDocProcessor.new.transform(input,output)
