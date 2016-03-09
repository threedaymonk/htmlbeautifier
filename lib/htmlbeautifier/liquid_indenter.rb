module HtmlBeautifier
  class LiquidIndenter
    LIQUID_INDENT_KEYWORDS =
      %w[if elsif else unless for comment capture raw case when]
    LIQUID_OUTDENT_KEYWORDS =
      %w[elsif else endif endunless endfor endcomment endcapture endraw
          endcase]
    LIQUID_INDENT  = %r{
      ^ ( #{LIQUID_INDENT_KEYWORDS.join("|")} )\b
      | \b ( do | \{ ) ( \s* \| [^\|]+ \| )? $
    }xo
    LIQUID_OUTDENT = %r{ ^ ( #{LIQUID_OUTDENT_KEYWORDS.join("|")} | \} ) \b }xo

    def outdent?(lines)
      lines.first =~ LIQUID_OUTDENT
    end

    def indent?(lines)
      lines.last =~ LIQUID_INDENT
    end
  end
end
