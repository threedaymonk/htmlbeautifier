require 'htmlbeautifier/parser'

module HtmlBeautifier
  class HtmlParser < Parser
    ELEMENT_CONTENT = %r{ (?:[^<>]|<%.*?%>)* }mx
    HTML_VOID_ELEMENTS = %r{(?:
      area | base | br | col | command | embed | hr | img | input | keygen |
      link | meta | param | source | track | wbr
    )}mix
    HTML_BLOCK_ELEMENTS = %r{(?:
      address | blockquote | center | dd | dir | div | dl | dt | fieldset |
      form | h1 | h2 | h3 | h4 | h5 | h6 | hr | isindex | li | menu |
      noframes | noscript | ol | p | pre | table | tbody | td | tfoot | th |
      thead | tr | ul
    )}mix

    def initialize
      super do |p|
        p.map %r{(<%-?=?)(.*?)(-?%>)}m,
          :embed
        p.map %r{<!--\[.*?\]>}m,
          :open_ie_cc
        p.map %r{<!\[.*?\]-->}m,
          :close_ie_cc
        p.map %r{<!--.*?-->}m,
          :standalone_element
        p.map %r{<!.*?>}m,
          :standalone_element
        p.map %r{(<script#{ELEMENT_CONTENT}>)(.*?)(</script>)}mi,
          :foreign_block
        p.map %r{(<style#{ELEMENT_CONTENT}>)(.*?)(</style>)}mi,
          :foreign_block
        p.map %r{(<pre#{ELEMENT_CONTENT}>)(.*?)(</pre>)}mi,
          :preformatted_block
        p.map %r{<#{ELEMENT_CONTENT}/>}m,
          :standalone_element
        p.map %r{<#{HTML_VOID_ELEMENTS}(?: #{ELEMENT_CONTENT})?>}m,
          :standalone_element
        p.map %r{</#{HTML_BLOCK_ELEMENTS}>}m,
          :close_block_element
        p.map %r{<#{HTML_BLOCK_ELEMENTS}(?: #{ELEMENT_CONTENT})?>}m,
          :open_block_element
        p.map %r{</#{ELEMENT_CONTENT}>}m,
          :close_element
        p.map %r{<#{ELEMENT_CONTENT}>}m,
          :open_element
        p.map %r{\s*\r?\n\s*}m,
          :new_line
        p.map %r{[^<]+},
          :text
      end
    end
  end
end
