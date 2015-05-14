require 'rexml/document'
require 'xmltransformer'

# This class can detect the transformation script parameter passed to the <strong>ruxed</strong> processing instruction
# if this instruction is present in the source xml
class RUXEDParameterDetector < XMLTransformer
  attr_reader :transform
  attr_reader :view
  
  def detect input_xml
    self.with_document_do(input_xml) { |doc|
      self.apply doc
    }
    self
  end #detect
  
  def process_ruxed anElement
    anElement.content.split.each { |pair|
      kv = pair.split("=")    
      @transform = kv[1] if kv[0] == 'transform'
      @view = kv[1] if kv[0] == 'view'
    }
    @abort = true # this terminates the loop for all elements of the xml source
  end #process_ruxt
  
  # This is a no-transform.
  def default_handler anElement
    self.apply anElement
  end
  
  # Ignore the text of the node
  def handleTextNode someText
  end 
  
end #class