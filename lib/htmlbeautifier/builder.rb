require "htmlbeautifier/parser"
require "htmlbeautifier/ruby_indenter"
require "htmlbeautifier/liquid_indenter"

module HtmlBeautifier
  class Builder
    DEFAULT_OPTIONS = {
      indent: "  ",
      initial_level: 0,
      stop_on_errors: false
    }

    def initialize(output, options = {})
      options = DEFAULT_OPTIONS.merge(options)
      @tab = options[:indent]
      @stop_on_errors = options[:stop_on_errors]
      @level = options[:initial_level]
      @new_line = false
      @empty = true
      @ie_cc_levels = []
      @output = output
      @embedded_indenter = RubyIndenter.new
      @liquid_indenter = LiquidIndenter.new
    end

  private

    def error(text)
      return unless @stop_on_errors
      raise text
    end

    def indent
      @level += 1
    end

    def outdent
      error "Extraneous closing tag" if @level == 0
      @level = [@level - 1, 0].max
    end

    def emit(*strings)
      @output << "\n" if @new_line && !@empty
      @output << (@tab * @level) if @new_line
      @output << strings.join("")
      @new_line = false
      @empty = false
    end

    def new_line(*)
      @new_line = true
    end

    def embed(opening, code, closing)
      lines = code.split(%r{\n}).map(&:strip)
      outdent if @embedded_indenter.outdent?(lines)
      emit opening, code, closing
      indent if @embedded_indenter.indent?(lines)
    end

    def liquid(opening, code, closing)
      lines = code.split(%r{\n}).map(&:strip)
      outdent if @liquid_indenter.outdent?(lines)
      emit opening, code, closing
      indent if @liquid_indenter.indent?(lines)
    end

    def foreign_block(opening, code, closing)
      emit opening
      emit_reindented_block_content code unless code.strip.empty?
      emit closing
    end

    def emit_reindented_block_content(code)
      lines = code.strip.split(%r{\n})
      indentation = lines.first[%r{^\s+}]

      indent
      new_line
      lines.each do |line|
        emit line.rstrip.sub(%r{^#{indentation}}, "")
        new_line
      end
      outdent
    end

    def preformatted_block(opening, content, closing)
      new_line
      emit opening, content, closing
      new_line
    end

    def standalone_element(e)
      emit e
      new_line if e =~ %r{^<br[^\w]}
    end

    def close_element(e)
      outdent
      emit e
    end

    def close_block_element(e)
      close_element e
      new_line
    end

    def open_element(e)
      emit e
      indent
    end

    def open_block_element(e)
      new_line
      open_element e
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
      new_line if t.end_with?("\n")
    end
  end
end
