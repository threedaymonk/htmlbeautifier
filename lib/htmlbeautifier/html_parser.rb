require 'htmlbeautifier/parser'

module HtmlBeautifier
  class HtmlParser < Parser
    ELEMENT_CONTENT = %r{ (?:[^<>]|<%.*?%>)* }mx

    def initialize
      super do
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
    end
  end
end
