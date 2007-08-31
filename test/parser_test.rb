require File.dirname(__FILE__) + '/test_helper'
require 'htmlbeautifier/parser'

class HtmlBeautifierParserTest < Test::Unit::TestCase
  
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
  
end
