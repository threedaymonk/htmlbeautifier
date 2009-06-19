require File.dirname(__FILE__) + '/test_helper'

class TestHtmlBeautifierIntegration < Test::Unit::TestCase
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
