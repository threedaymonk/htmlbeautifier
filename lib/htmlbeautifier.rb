require 'htmlbeautifier/builder'
require 'htmlbeautifier/html_parser'
require 'htmlbeautifier/version'

module HtmlBeautifier

  # Returns a beautified HTML/HTML+ERB document as a String.
  # html must be an object that responds to +#to_s+.
  #
  # Available options are:
  # tab_stops - an integer for the number of spaces to indent, default 2
  # stop_on_errors - raise an exception on a badly-formed document. Default
  # is false, i.e. continue to process the rest of the document.
  #
  def self.beautify(html, options = {})
    ''.tap { |output|
      HtmlParser.new.scan html.to_s, Builder.new(output, options)
    }
  end
end
