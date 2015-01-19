require 'htmlbeautifier/parser'

module HtmlBeautifier
  class Builder

    RUBY_INDENT  =
      %r{ ^ ( if | unless | while | begin | elsif | else )\b
        | \b ( do | \{ ) ( \s* \| [^\|]+ \| )? $
        }x
    RUBY_OUTDENT =
      %r{ ^ ( end | elsif | else |\} ) \b
        }x
    ELEMENT_CONTENT = %r{ (?:[^<>]|<%.*?%>)* }mx

    DEFAULT_OPTIONS = {
      tab_stops: 2,
      stop_on_errors: false
    }

    def initialize(output, options = {})
      options = DEFAULT_OPTIONS.merge(options)
      @level = 0
      @new_line = false
      @tab = ' ' * options[:tab_stops]
      @stop_on_errors = options[:stop_on_errors]
      @output = output
      @empty = true
      @ie_cc_levels = []
    end

  private

    def error(text)
      return unless @stop_on_errors
      raise RuntimeError, text
    end

    def indent
      @level += 1
    end

    def outdent
      error "Extraneous closing tag" if @level == 0
      @level = [@level - 1, 0].max
    end

    def emit(s)
      if @new_line && !@empty
        @output << ("\n" + @tab * @level)
      end
      @output << s
      @new_line = false
      @empty = false
    end

    def new_line(*_args)
      @new_line = true
    end

    def embed(opening, code, closing)
      lines = code.split(/\n/).map{ |l| l.strip }
      outdent if lines.first =~ RUBY_OUTDENT
      emit opening + code + closing
      indent if lines.last =~ RUBY_INDENT
    end

    def foreign_block(opening, code, closing)
      emit opening
      unless code.empty?
        indent

        lines = code.split(/\n/)
        lines.shift while lines.first.strip.empty?
        lines.pop while lines.last.strip.empty?
        indentation = lines.first[/^ +/]

        new_line
        lines.each do |line|
          emit line.rstrip.sub(/^#{indentation}/, '')
          new_line
        end

        outdent
      end
      emit closing
    end

    def preformatted_block(opening, content, closing)
      new_line
      emit opening
      emit content
      emit closing
      new_line
    end

    def standalone_element(e)
      emit e
      new_line if e =~ /^<br[^\w]/
    end

    def close_block_element(e)
      outdent
      emit e
      new_line
    end

    def open_block_element(e)
      new_line
      emit e
      indent
    end

    def close_element(e)
      outdent
      emit e
    end

    def open_element(e)
      emit e
      indent
    end

    def close_ie_cc(e)
      if @ie_cc_levels.empty?
        error "Unclosed conditional comment"
      else
        @level = @ie_cc_levels.pop
      end
      emit e
    end

    def open_ie_cc(e)
      emit e
      @ie_cc_levels.push @level
      indent
    end

    def text(t)
      emit t.chomp
      new_line if t.end_with? $/
    end
  end
end

