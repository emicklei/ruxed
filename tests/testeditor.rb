require 'win32ole'
require 'ruxed-transformer'
require 'ruxed-editor'

application = FXApp.new("RUXED", "Editor")
editor = RUXEDEditor.new(application)
application.create
application.run