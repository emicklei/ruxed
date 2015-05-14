require 'xmltransformer'
require 'thread'

class RUXEDTransformer
    attr_reader :transform_failed
    attr_reader :error_line
    attr_reader :error_pos
    
    def initialize
      @mutex = Mutex.new
    end
    
    # Transform the contents of the new xml file using the transformer defined in the script
    # Return the output file name or an empty string if the transformation failed
    def transform(input_xml, contents, producer_script, output_file)  
      @transform_failed = false
      @mutex.synchronize do
        unsafe_transform(input_xml, contents, producer_script, output_file)
      end
    end
    
    # Private method that does transformation for a single thread
    def unsafe_transform(input_xml, contents, producer_script, output_file)
        # puts "input=#{input_xml} output=#{output_file}"
        begin          
            # in any case, save the contents to the input file
            File.open(input_xml,'w'){|target| target << contents }
            # if no transform is request then output = input
            if producer_script.nil?
                File.open(output_file,'w') { |out| out << contents }
            else
                # always read the classname, it may have been changed
                clsname = self.defined_classname(producer_script)
                if clsname.size != 0
                    # always load the script, it may have been changed
                    load producer_script
                    # resolve the actual transformer class
                    cls = eval clsname
                    # do the transform, no logging, no error handling
                    here = Dir.pwd
                    cls.new.basic_transform input_xml, output_file
                end          
            end
         rescue REXML::ParseException
            @transform_failed = true
            @error_line = $!.line
            @error_pos = $!.position
         rescue StandardError 
            puts "[ruxed] transform failed:#{$!}"
         end
    end
    
    # Try to determine what class is being defined by a script stored in a filename
    # Return the name of the class or an empty string is none was detected
    def defined_classname filename
        script = File.new filename
        script.each_line do |line|
             if line =~ /class(.*)[<|\z]/  
                script.close
                return $1.strip
             end
        end       
        script.close 
        ""
    end
        
end