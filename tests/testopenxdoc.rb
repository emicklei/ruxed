require 'win32ole'
load 'ruxed-transformer.rb'
load 'ruxed-editor.rb'

# create app and editor
application = FXApp.new("RUXED", "Editor")
editor = RUXEDEditor.new(application)

# Start IE
ie = WIN32OLE.new('InternetExplorer.Application')
ie.visible = TRUE    

# and connect
editor.ie = ie
editor.current_xml = File.join(Dir.pwd,'../samples/sample.xml')
editor.current_processor = File.join(Dir.pwd,'../samples/sample.rb')
editor.output_file = File.join(Dir.pwd,'../samples/sample.html')
editor.read_transform_show

# open editor
application.create
# Process user-input
application.run