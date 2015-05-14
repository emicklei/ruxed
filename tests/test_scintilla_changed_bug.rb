require 'fox14'
require 'fox14/scintilla'

include Fox

class ScintillaTest < FXMainWindow
  def initialize(app)
    super(app, "ScintillaTest")
    @txt = <<BEGIN
Some text
BEGIN
    scintilla = FXScintilla.new(self, nil, 0,TEXT_WORDWRAP|LAYOUT_FILL_X|LAYOUT_FILL_Y)
    scintilla.setText(@txt)
    scintilla.connect(SEL_CHANGED) do |sender, selector, fxevent|
        puts 'about to display event...'
        puts fxevent
    end
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
  
end

application = FXApp.new("Test", "Scintilla")
test = ScintillaTest.new(application)
application.create
# Process user-input
application.run