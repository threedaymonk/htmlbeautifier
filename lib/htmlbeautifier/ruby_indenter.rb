module HtmlBeautifier
  class RubyIndenter
    INDENT_KEYWORDS = %w[ if elsif else unless while until begin for ]
    OUTDENT_KEYWORDS = %w[ elsif else end ]
    RUBY_INDENT  = %r{
      ^ ( #{INDENT_KEYWORDS.join("|")} )\b
      | \b ( do | \{ ) ( \s* \| [^\|]+ \| )? $
    }xo
    RUBY_OUTDENT = %r{ ^ ( #{OUTDENT_KEYWORDS.join("|")} | \} ) \b }xo

    def outdent?(lines)
      lines.first =~ RUBY_OUTDENT
    end

    def indent?(lines)
      lines.last =~ RUBY_INDENT
    end
  end
end
