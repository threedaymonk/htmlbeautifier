require 'htmlbeautifier/builder'
require 'htmlbeautifier/html_parser'
require 'htmlbeautifier/version'

module HtmlBeautifier

  # Returns a beautified HTML/HTML+ERB document as a String.
  # html must be an object that responds to +#to_s+.
  #
  # Available options are:
  # tab_stops - an integer for the number of spaces to indent, default 2
  #
  def self.beautify(html, options = {})
    tab_stops = options.fetch(:tab_stops, 2)
    ''.tap { |output|
      HtmlParser.new.scan html.to_s, Builder.new(output, tab_stops)
    }
  end
end
