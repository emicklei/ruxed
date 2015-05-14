#!/usr/bin/env ruby

require 'fox16'
require 'fox16/colors'
require 'fox16/scintilla'

include Fox

class RUXEDEditor < FXMainWindow
  attr_accessor :transformer
  attr_accessor :ie
  attr_accessor :current_xml
  attr_accessor :current_processor
  attr_accessor :output_file
  
  def initialize(app)
    # Call the base class initialize() first
    super(app, "Ruxed - XML file editor")
    self.width = 400
    self.height = 600
    @transformer = RUXEDTransformer.new
    self.add_widgets
  end
  
  # Install an event handler on the Scintilla editor to
  # get notified about changes in the text being edited.
  def listen_to_changed
    @text.connect(SEL_COMMAND) do |sender, selector, scnotification| #SEL_KEYRELEASE
      #ignore cursor control keys
      #if [KEY_Left,KEY_Right,KEY_Up,KEY_Down,
      #  KEY_Page_Up,KEY_Page_Down,KEY_Begin,KEY_End,KEY_Home].include? fxevent.code
      #else 
      #             
      #end
      if scnotification.nmhdr.code == FXScintilla::SCN_MODIFIED
        if (scnotification.modificationType & FXScintilla::SC_PERFORMED_USER == FXScintilla::SC_PERFORMED_USER)
          if (scnotification.modificationType & 0x1 == 0x1) || (scnotification.modificationType & 0x2 == 0x2)
            self.transform_show
          end
        end
      end
    end #do
  end #listen
  
  def add_widgets
    # Menu bar, along the top
    menubar = FXMenuBar.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    
    # Button bar along the bottom
    buttons = FXHorizontalFrame.new(self, LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X)
    
    # The frame takes up the rest of the space
    textframe = FXHorizontalFrame.new(self, LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y|FRAME_SUNKEN|FRAME_THICK)
    
    # File menu
    filemenu = FXMenuPane.new(self)
    FXMenuCommand.new(filemenu, "&Quit\tCtl-Q\tQuit the application.", nil,
    getApp(), FXApp::ID_QUIT)
    FXMenuTitle.new(menubar, "&File", nil, filemenu)
    
    # Text window
    @text = FXScintilla.new(textframe, nil, 0,TEXT_WORDWRAP|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    # @text.setFont(FXFont.new(getApp(),"courier,100"))
    @text.setMarginTypeN(0,1)
    @text.setMarginWidthN(0,20)
    @text.setModEventMask(0x1 | 0x2)
    @text.setLexer(FXScintilla::SCLEX_XML)
    self.listen_to_changed
  end
  
  # Read ,transform and show
  def read_transform_show
    File.open(@current_xml,'r') do | f |
      @text.setText(f.read)
    end
    self.transform_show
  end
  
  # Run the transformer and if it was succesful then show the resulting HTML file through IE
  def transform_show
    @transformer.transform(@current_xml,@text.getText(@text.getLength+1),@current_processor, @output_file)
    if @transformer.transform_failed
      puts "[ruxed] ERROR on line:#{@transformer.error_line} at:#{@transformer.error_pos}"
    end
    begin
      @ie.navigate(@output_file) unless @ie.nil? || @output_file.nil?
    rescue WIN32OLERuntimeError
      puts "IE is gone"
      # mark as unavailable
      @ie = nil
    end
  end
  
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end


