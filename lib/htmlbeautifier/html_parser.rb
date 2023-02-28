# frozen_string_literal: true

require "htmlbeautifier/parser"

module HtmlBeautifier
  class HtmlParser < Parser
    ELEMENT_CONTENT = %r{ (?:<%.*?%>|[^>])* }mx
    HTML_VOID_ELEMENTS = %w[
      area base br col command embed hr img input keygen
      link meta param source track wbr
    ]
    HTML_BLOCK_ELEMENTS = %w[
      address article aside audio blockquote canvas dd details
      dir div dl dt fieldset figcaption figure footer form
      h1 h2 h3 h4 h5 h6 header hr li menu noframes
      noscript ol p pre section table tbody td tfoot th
      thead tr ul video
    ].freeze

    def self.void_elements
      @void_elements ||= HTML_VOID_ELEMENTS.dup
    end

    def self.block_elements
      @block_elements ||= HTML_BLOCK_ELEMENTS.dup
    end

    def self.void_elements_regexp
      %r{(?:#{void_elements.join("|")})}mix
    end

    def self.block_elements_regexp
      %r{(?:#{block_elements.join("|")})}mix
    end

    def self.mappings
      [
        [%r{(<%-?=?)(.*?)(-?%>)}om,
          :embed],
        [%r{<!--\[.*?\]>}om,
          :open_ie_cc],
        [%r{<!\[.*?\]-->}om,
          :close_ie_cc],
        [%r{<!--.*?-->}om,
          :standalone_element],
        [%r{<!.*?>}om,
          :standalone_element],
        [%r{(<script#{ELEMENT_CONTENT}>)(.*?)(</script>)}omi,
          :foreign_block],
        [%r{(<style#{ELEMENT_CONTENT}>)(.*?)(</style>)}omi,
          :foreign_block],
        [%r{(<pre#{ELEMENT_CONTENT}>)(.*?)(</pre>)}omi,
          :preformatted_block],
        [%r{(<textarea#{ELEMENT_CONTENT}>)(.*?)(</textarea>)}omi,
          :preformatted_block],
        [%r{<#{void_elements_regexp}(?: #{ELEMENT_CONTENT})?/?>}om,
          :standalone_element],
        [%r{</#{block_elements_regexp}>}om,
          :close_block_element],
        [%r{<#{block_elements_regexp}(?: #{ELEMENT_CONTENT})?>}om,
          :open_block_element],
        [%r{</#{ELEMENT_CONTENT}>}om,
          :close_element],
        [%r{<#{ELEMENT_CONTENT}[^/]>}om,
          :open_element],
        [%r{<[\w\-]+(?: #{ELEMENT_CONTENT})?/>}om,
          :standalone_element],
        [%r{(\s*\r?\n\s*)+}om,
          :new_lines],
        [%r{[^<\n]+},
          :text]
      ]
    end

    def initialize
      super do |p|
        self.class.mappings.each do |regexp, method|
          p.map regexp, method
        end
      end
    end
  end
end
