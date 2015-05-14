require 'htmlproducer'
#require 'profile'

class DocProducer < HTMLProducer  

    # DOC
    def handle_doc anElement    
        self.doctype_html
        markup.html { 
            self.style_css 'sample.css'
            markup.body {                
                self.apply anElement }}
    end
    
    #TITLE
    def handle_title anElement
        markup.h1{self.apply anElement}        
    end
    
    # CHAPTER
    def handle_chapter anElement
        markup.h2 anElement.attributes["title"]
        self.apply anElement
    end   
    
    # SECTION
    def handle_section anElement
        markup.p
        markup.table(:class => 'section' ) {
            markup.tr {
                markup.th(anElement.attributes["title"])}                
            markup.tr {
                markup.td {
                    self.apply anElement }}}
    end
end