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

    def initialize(output, tab_stops)
      @level = 0
      @new_line = false
      @tab = ' ' * tab_stops
      @output = output
      @ie_cc_levels = []
    end

    def indent
      @level += 1
    end

    def outdent
      @level -= 1
      raise "Outdented too far" if @level < 0
    end

    def emit(s)
      if @new_line && !@output.empty?
        @output << ("\n" + @tab * @level)
      end
      @output << s
      @new_line = false
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
      emit opening
      emit content
      emit closing
    end

    def standalone_element(e)
      emit e
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
      raise "Unclosed conditional comment" if @ie_cc_levels.empty?
      @level = @ie_cc_levels.pop
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

