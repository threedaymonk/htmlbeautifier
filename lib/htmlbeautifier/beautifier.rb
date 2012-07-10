require 'htmlbeautifier/parser'
require 'htmlbeautifier/builder'

module HtmlBeautifier
  class Beautifier
    ELEMENT_CONTENT = %r{ (?:[^<>]|<%.*?%>)* }mx

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
      html = html.strip.gsub(/\t/, ' ' * self.tab_stops)
      @parser = Parser.new do
        map %r{(<%-?=?)(.*?)(-?%>)}m,                           :embed
        map %r{<!--\[.*?\]>}m,                                  :open_element
        map %r{<!\[.*?\]-->}m,                                  :close_element
        map %r{<!--.*?-->}m,                                    :standalone_element
        map %r{<!.*?>}m,                                        :standalone_element
        map %r{(<script#{ELEMENT_CONTENT}>)(.*?)(</script>)}m,  :foreign_block
        map %r{(<style#{ELEMENT_CONTENT}>)(.*?)(</style>)}m,    :foreign_block
        map %r{<#{ELEMENT_CONTENT}/>}m,                         :standalone_element
        map %r{</#{ELEMENT_CONTENT}>}m,                         :close_element
        map %r{<#{ELEMENT_CONTENT}>}m,                          :open_element
        map %r{\s+},                                            :whitespace
        map %r{[^<]+},                                          :text
      end
      @parser.scan html, Builder.new(@output, self.tab_stops)
    end
  end
end
