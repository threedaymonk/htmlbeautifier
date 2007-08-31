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
    # puts expected
    # puts actual
    assert_equal expected, actual
  end
  
end

class HtmlBeautifierRegressionTest < Test::Unit::TestCase
  
  include HtmlBeautifierTestUtilities
  
  def setup
    # HtmlBeautifier::Parser.debug_block{ |match, method| puts("#{match.inspect} => #{method}") }
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
  
  def test_should_skip_over_empty_scripts
    source = %q(<script src="/foo.js" type="text/javascript" charset="utf-8"></script>)
    expected = source
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
  
  def test_should_indent_divs_containing_standalone_elements
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
    expected = source
    assert_beautifies expected, source
  end
  
  def test_should_not_break_line_on_embedded_code_within_script_opening_element
    source = '<script src="<%= path %>" type="text/javascript"></script>'
    expected = source
    assert_beautifies expected, source
  end

  def test_should_not_break_line_on_embedded_code_within_normal_element
    source = '<img src="<%= path %>" alt="foo" />'
    expected = source
    assert_beautifies expected, source
  end
  
  def test_should_indent_inside_IE_conditional_comments
    source = code(%q(
      <!--[if IE 6]>
      <link rel="stylesheet" href="/stylesheets/ie6.css" type="text/css" />
      <![endif]-->
      <!--[if IE 5]>
      <link rel="stylesheet" href="/stylesheets/ie5.css" type="text/css" />
      <![endif]-->
    ))
    expected = code(%q(
      <!--[if IE 6]>
        <link rel="stylesheet" href="/stylesheets/ie6.css" type="text/css" />
      <![endif]-->
      <!--[if IE 5]>
        <link rel="stylesheet" href="/stylesheets/ie5.css" type="text/css" />
      <![endif]-->
    ))
    assert_beautifies expected, source
  end
  
end

class HtmlBeautifierIntegrationTest < Test::Unit::TestCase
  
  include HtmlBeautifierTestUtilities
  
  def test_should_correctly_indent_mixed_document
    source = code(%q(
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
      <head>
      <meta http-equiv="content-type" content="text/html; charset=utf-8" />
      <script src="/javascripts/prototype.js" type="text/javascript"></script>
      <link rel="stylesheet" type="text/css" href="/stylesheets/screen.css" media="screen"/>
      <!--[if IE 6]>
      <link rel="stylesheet" href="/stylesheets/screen_ie6.css" type="text/css" />
      <![endif]-->
      <title>Title Goes Here</title>
      <script type="text/javascript" charset="utf-8">
      doSomething();
      </script>
      </head>
      <body>
      <div id="something">
      <h1>
      Heading 1
      </h1>
      </div>
      <div id="somethingElse">
      <p>Lorem Ipsum</p>
      <% if @x %>
      <% @ys.each do |y| %>
      <p>
      <%= h y %>
      </p>
      <% end %>
      <% elsif @z %>
      <hr />
      <% end %>
      </div>
      </body>
      </html>
    ))
    expected = code(%q(
      <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
      <html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
        <head>
          <meta http-equiv="content-type" content="text/html; charset=utf-8" />
          <script src="/javascripts/prototype.js" type="text/javascript"></script>
          <link rel="stylesheet" type="text/css" href="/stylesheets/screen.css" media="screen"/>
          <!--[if IE 6]>
            <link rel="stylesheet" href="/stylesheets/screen_ie6.css" type="text/css" />
          <![endif]-->
          <title>Title Goes Here</title>
          <script type="text/javascript" charset="utf-8">
            doSomething();
          </script>
        </head>
        <body>
          <div id="something">
            <h1>
              Heading 1
            </h1>
          </div>
          <div id="somethingElse">
            <p>Lorem Ipsum</p>
            <% if @x %>
              <% @ys.each do |y| %>
                <p>
                  <%= h y %>
                </p>
              <% end %>
            <% elsif @z %>
              <hr />
            <% end %>
          </div>
        </body>
      </html>
    ))
    assert_beautifies expected, source
  end

end
