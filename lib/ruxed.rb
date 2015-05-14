require 'win32ole'
require 'ruxed-transformer'
require 'ruxed-editor'
require 'ruxed-parameter-detector'

def expand_to_pwd filename
  if filename.nil? 
    return nil
  end
  if File.dirname(filename) =~ /\./
    File.join(Dir.pwd,filename)
  else
    filename
  end
end

# process program arguments first
if ARGV.size == 0
  explain = <<EOEX
    
Ruxed is a simple XML editor that uses a Ruby script for transformation 
and the Internet Explorer for on-the-fly viewing.
    
Usage:
	ruxed input
	ruxed input output
	ruxed input transformation	output
    	
Examples:
	ruxed xdoc.xml xdoc.rb xdoc.html
	ruxed sample sample
	ruxed plain
    	
Further information:
	http://www.philemonworks.com/ruxed
	see the samples directory of this gem
EOEX
  puts explain
  exit
end

# make sure input has correct extension
input_xml = expand_to_pwd ARGV[0]
if !(input_xml =~ /.*\.xml/) 
  input_xml += '.xml'
end
if not(test(?e,input_xml))
  puts "Sorry, input file does not exist: #{input_xml}" 
  exit
end
if not(test(?w,input_xml))
  puts "Sorry, input file is read-only: #{input_xml}" 
  exit
end

# if transform script is passed, check it
unless (transform_script = expand_to_pwd ARGV[1]).nil?
  if !(transform_script =~ /.*\.rb/) 
    transform_script += '.rb'
  end
  if not(test(?e,transform_script))
    puts "Sorry, transform script does not exist: #{transform_script}" 
    exit
  end
end

# if transform script is unkown, try detecting it from the xml
if transform_script.nil?
  detector = RUXEDParameterDetector.new.detect(input_xml)
  transform_script = expand_to_pwd(detector.transform)
  output_file = expand_to_pwd(detector.view)
  if transform_script && !(test(?e,transform_script))
    puts "Sorry, transform script does not exist: #{transform_script}" 
    exit
  end  
end

#if output file us unknown then use a temporary file
if output_file.nil?
  if (output_file = expand_to_pwd ARGV[2]).nil?
    output_file = File.join(ENV['TEMP'],ARGV[0] + '.html')
  end
end

# create app and editor
application = FXApp.new("RUXED", "Editor")
editor = RUXEDEditor.new(application)

# Start IE
ie = WIN32OLE.new('InternetExplorer.Application')
ie.visible = TRUE    

# and connect
editor.ie = ie
editor.current_xml = input_xml
editor.current_processor = transform_script
editor.output_file = output_file

# report
puts "[ruxed] input=" + input_xml
puts "[ruxed] transform=" + (editor.current_processor || '<none>')
puts "[ruxed] output=" + editor.output_file

editor.read_transform_show

# open editor
application.create
# Process user-input
application.run

# close IE too
ie.visible = false 
ie.ole_free
