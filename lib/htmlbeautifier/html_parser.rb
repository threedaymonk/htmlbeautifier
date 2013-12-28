require 'htmlbeautifier/parser'

module HtmlBeautifier
  class HtmlParser < Parser
    ELEMENT_CONTENT = %r{ (?:[^<>]|<%.*?%>)* }mx
    HTML_VOID_ELEMENTS = %w[area base br col command embed hr img input keygen link meta param source track wbr].join("|")

    def initialize
      super do |p|
        p.map %r{(<%-?=?)(.*?)(-?%>)}m,                           :embed
        p.map %r{<!--\[.*?\]>}m,                                  :open_ie_cc
        p.map %r{<!\[.*?\]-->}m,                                  :close_ie_cc
        p.map %r{<!--.*?-->}m,                                    :standalone_element
        p.map %r{<!.*?>}m,                                        :standalone_element
        p.map %r{(<script#{ELEMENT_CONTENT}>)(.*?)(</script>)}m,  :foreign_block
        p.map %r{(<style#{ELEMENT_CONTENT}>)(.*?)(</style>)}m,    :foreign_block
        p.map %r{<#{ELEMENT_CONTENT}/>}m,                         :standalone_element
        p.map %r{(<(?i:#{HTML_VOID_ELEMENTS})#{ELEMENT_CONTENT}>)}m, :standalone_element
        p.map %r{</#{ELEMENT_CONTENT}>}m,                         :close_element
        p.map %r{<#{ELEMENT_CONTENT}>}m,                          :open_element
        p.map %r{\s+},                                            :whitespace
        p.map %r{[^<]+},                                          :text
      end
    end
  end
end
