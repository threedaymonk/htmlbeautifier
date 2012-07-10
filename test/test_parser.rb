require 'test_helper'
require 'htmlbeautifier/parser'

class TestParser < Test::Unit::TestCase

  class Receiver
    attr_reader :sequence

    def initialize
      @sequence = []
    end

    def method_missing(method, *params)
      @sequence << [method, params]
    end
  end

  def setup
    # HtmlBeautifier::Parser.debug_block{ |match, method| puts("#{match.inspect} => #{method}") }
  end

  def test_should_dispatch_matching_sequence
    receiver = Receiver.new
    parser = HtmlBeautifier::Parser.new{
      map %r{foo}, :foo
      map %r{bar\s*}, :bar
      map %r{\s+}, :whitespace
    }
    parser.scan('foo bar ', receiver)
    assert_equal [[:foo, ['foo']], [:whitespace, [' ']], [:bar, ['bar ']]], receiver.sequence
  end

  def test_should_send_parenthesized_components_as_separate_parameters
    receiver = Receiver.new
    parser = HtmlBeautifier::Parser.new{
      map %r{(foo)\((.*?)\)}, :foo
    }
    parser.scan('foo(bar)', receiver)
    assert_equal [[:foo, ['foo', 'bar']]], receiver.sequence
  end

  class SourceTrackingReceiver < Receiver
    attr_reader :sources_so_far
    attr_reader :source_line_numbers

    def initialize(parser)
      @sources_so_far = []
      @source_line_numbers = []
      @parser = parser
      super()
    end

    def append_new_source_so_far(*ignored)
      @sources_so_far << @parser.source_so_far
    end

    def append_new_source_line_number(*ignored)
      @source_line_numbers << @parser.source_line_number
    end
  end

  def test_should_give_source_so_far
    parser = HtmlBeautifier::Parser.new{
      map %r{(M+)}m, :append_new_source_so_far
      map %r{([\s\n]+)}m, :space_or_newline
    }
    receiver = SourceTrackingReceiver.new(parser)
    parser.scan("M MM MMM", receiver)
    assert_equal ['M', 'M MM', 'M MM MMM'], receiver.sources_so_far
  end

  def test_should_give_source_line_number
    parser = HtmlBeautifier::Parser.new{
      map %r{(M+)}m, :append_new_source_line_number
      map %r{([\s\n]+)}m, :space_or_newline
    }
    receiver = SourceTrackingReceiver.new(parser)
    parser.scan("M \n\nMM\nMMM", receiver)
    assert_equal [1, 3, 4], receiver.source_line_numbers
  end

end
