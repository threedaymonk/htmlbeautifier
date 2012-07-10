require 'htmlbeautifier/html_parser'
require 'htmlbeautifier/builder'

module HtmlBeautifier
  class Beautifier
    attr_accessor :tab_stops

    # Create a new Beautifier.
    # output should be an object that responds to <<
    # i.e. a String or an IO
    def initialize(output)
      self.tab_stops = 2
      @output = output
    end

    # Process an HTML/HTML+ERB document
    # html should be a string
    def scan(html)
      @parser = HtmlParser.new
      @parser.scan html.strip, Builder.new(@output, self.tab_stops)
    end
  end
end
