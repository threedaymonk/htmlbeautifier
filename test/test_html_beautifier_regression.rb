require 'test_helper'
require 'htmlbeautifier/beautifier'

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
    source   = %Q(<script>\n  f();  \n</script>)
    expected = %Q(<script>\n  f();\n</script>)
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
    source   = %Q(<style>\n  .foo{ margin: 0; }  \n</style>)
    expected = %Q(<style>\n  .foo{ margin: 0; }\n</style>)
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

  def test_should_outdent_else
    source = code(%q(
      <% if @x %>
      Foo
      <% else %>
      Bar
      <% end %>
    ))
    expected = code(%q(
      <% if @x %>
        Foo
      <% else %>
        Bar
      <% end %>
    ))
    assert_beautifies expected, source
  end

  def test_should_indent_with_hyphenated_erb_tags
    source = code(%q(
      <%- if @x -%>
      <%- @ys.each do |y| -%>
      <p>Foo</p>
      <%- end -%>
      <%- elsif @z -%>
      <hr />
      <%- end -%>
    ))
    expected = code(%q(
      <%- if @x -%>
        <%- @ys.each do |y| -%>
          <p>Foo</p>
        <%- end -%>
      <%- elsif @z -%>
        <hr />
      <%- end -%>
    ))
    assert_beautifies expected, source
  end

  def test_should_not_indent_comments
    source = code(%q(
      <!-- This is a comment -->
      <!-- So is this -->
    ))
    assert_beautifies source, source
  end

  def test_should_not_indent_conditional_comments
    source = code(%q(
      <!--[if lt IE 7]><html lang="en-us" class="ie6"><![endif]-->
      <!--[if IE 7]><html lang="en-us" class="ie7"><![endif]-->
      <!--[if IE 8]><html lang="en-us" class="ie8"><![endif]-->
      <!--[if gt IE 8]><!--><html lang="en-us"><!--<![endif]-->
        <body>
        </body>
      </html>
    ))
    assert_beautifies source, source
  end

  def test_should_not_indent_doctype
    source = code(%q(
      <!DOCTYPE html>
      <html>
      </html>
    ))
    assert_beautifies source, source
  end

  def test_should_not_indent_html_void_elements
    source = code(%q(
    <meta>
    <input id="id">
    <br>
    ))
    assert_beautifies source, source
  end

  def test_should_ignore_case_of_void_elements
    source = code(%q(
    <META>
    <INPUT id="id">
    <BR>
    ))
    assert_beautifies source, source
  end

end
