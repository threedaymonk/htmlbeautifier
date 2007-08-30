require File.dirname(__FILE__) + '/test_helper'
require 'htmlbeautifier/beautifier'

module HtmlBeautifierTestUtilities
  
  def code(str)
    str = str.gsub(/\A\n|\n\s*\Z/, '')
    indentation = str[/\A +/]
    lines = str.split(/\n/)
    lines.map{ |line| line.sub(/^#{indentation}/, '') }.join("\n")
  end
  
  def assert_beautifies(expected, source)
    actual = ''
    beautifier = HtmlBeautifier::Beautifier.new(actual)
    beautifier.scan(source)
    assert_equal expected, actual
  end
  
end

class HtmlBeautifierRegressionTest < Test::Unit::TestCase
  
  include HtmlBeautifierTestUtilities
  
  def setup
    # HtmlBeautifier::Parser.debug_block{ |match, method|
    #   puts("#{match.inspect} => #{method}")
    # }
  end
  
  def test_should_ignore_html_fragments_in_embedded_code
    source = code(%q(
      <div>
        <%= a[:b].gsub("\n","<br />\n") %>
      </div>
    ))
    expected = code(%q(
      <div>
        <%= a[:b].gsub("\n","<br />\n") %>
      </div>
    ))
    assert_beautifies expected, source
  end
  
  def test_should_indent_scripts
    source = code(%q(
      <script>
      function(f) {
          g();
          return 42;
      }
      </script>
    ))
    expected = code(%q(
      <script>
        function(f) {
            g();
            return 42;
        }
      </script>
    ))
    assert_beautifies expected, source
  end
  
  def test_should_remove_blank_lines_around_scripts
    source = code(%q(
      <script>
      
        f();
      
      </script>
    ))
    expected = code(%q(
      <script>
        f();
      </script>
    ))
    assert_beautifies expected, source
  end
  
  def test_should_remove_trailing_space_from_script_lines
    source = code(%q(
      <script>
        f();  
      </script>
    ))
    expected = code(%q(
      <script>
        f();
      </script>
    ))
    assert_beautifies expected, source
  end
  
  def test_should_indent_styles
    source = code(%q(
      <style>
      .foo{ margin: 0; }
      .bar{
        padding: 0;
        margin: 0;
      }
      </style>
    ))
    expected = code(%q(
      <style>
        .foo{ margin: 0; }
        .bar{
          padding: 0;
          margin: 0;
        }
      </style>
    ))
    assert_beautifies expected, source
  end
  
  def test_should_remove_blank_lines_around_styles
    source = code(%q(
      <style>
      
        .foo{ margin: 0; }
      
      </style>
    ))
    expected = code(%q(
      <style>
        .foo{ margin: 0; }
      </style>
    ))
    assert_beautifies expected, source
  end

  def test_should_remove_trailing_space_from_style_lines
    source = code(%q(
      <style>
        .foo{ margin: 0; }  
      </style>
    ))
    expected = code(%q(
      <style>
        .foo{ margin: 0; }
      </style>
    ))
    assert_beautifies expected, source
  end
  
  def test_should_indent_nested_divs
    source = code(%q(
      <div>
        <div>
          <img src="foo" alt="" />
        </div>
        <div>
          <img src="foo" alt="" />
        </div>
      </div>
    ))
    assert_beautifies source, source
  end
  
end
