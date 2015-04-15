require "strscan"

module HtmlBeautifier
  class Parser
    def initialize
      @maps = []
      yield self if block_given?
    end

    def map(pattern, method)
      @maps << [pattern, method]
    end

    def scan(subject, receiver)
      @scanner = StringScanner.new(subject)
      dispatch(receiver) until @scanner.eos?
    end

    def source_so_far
      @scanner.string[0...@scanner.pos]
    end

    def source_line_number
      [source_so_far.chomp.split(%r{\n}).count, 1].max
    end

  private

    def dispatch(receiver)
      @maps.each do |pattern, method|
        if @scanner.scan(pattern)
          params = []
          i = 1
          while @scanner[i]
            params << @scanner[i]
            i += 1
          end
          params = [@scanner[0]] if params.empty?
          receiver.__send__(method, *params)
          return
        end
      end
      raise "Unmatched sequence"
    rescue => ex
      raise "#{ex.message} on line #{source_line_number}"
    end
  end
end
