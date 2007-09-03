require 'strscan'

module HtmlBeautifier
  class Parser
  
    def self.debug_block(&blk)
      @debug_block = blk
    end
  
    def self.debug(match, method)
      if defined? @debug_block
        @debug_block.call(match, method)
      end
    end
  
    def initialize(&blk)
      @maps = []
      if block_given?
        self.instance_eval(&blk)
      end
    end
  
    def map(pattern, method)
      @maps << [pattern, method]
    end
  
    def scan(subject, receiver)
      scanner = StringScanner.new(subject)
      until scanner.eos?
        dispatch(scanner, receiver)
      end
    end
  
    def dispatch(scanner, receiver)
      @maps.each do |pattern, method|
        if scanner.scan(pattern)
          params = []
          i = 1
          while scanner[i]
            params << scanner[i]
            i += 1
          end
          params = [scanner[0]] if params.empty?
          self.class.debug(scanner[0], method)
          receiver.__send__(method, *params)
          return
        end
      end
      raise "Unmatched sequence #{match.inspect}"
    end
  
  end
end
