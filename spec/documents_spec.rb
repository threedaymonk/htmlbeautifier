# frozen_string_literal: true

require "htmlbeautifier"

describe HtmlBeautifier do
  it "correctly indents mixed document" do
    source = code <<~ERB
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
      <div id="somethingElse"><p>Lorem Ipsum</p>
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
      <table>
      <colgroup>
      <col style="width: 50%;">
      <col style="width: 50%;">
      </colgroup>
      <tbody>
      <tr><td>First column</td></tr><tr>
      <td>Second column</td></tr>
      </tbody>
      </table>
      </body>
      </html>
    ERB
    expected = code <<~ERB
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
          <table>
            <colgroup>
              <col style="width: 50%;">
              <col style="width: 50%;">
            </colgroup>
            <tbody>
              <tr>
                <td>First column</td>
              </tr>
              <tr>
                <td>Second column</td>
              </tr>
            </tbody>
          </table>
        </body>
      </html>
    ERB

    expect(described_class.beautify(source)).to eq(expected)
  end

  context "when stop_on_errors is true" do
    it "raises an error with the source line of an illegal closing tag" do
      expect {
        source = "<html>\n</html>\n</html>"
        described_class.beautify(source, stop_on_errors: true)
      }.to raise_error(RuntimeError, "Extraneous closing tag on line 3")
    end
  end

  context "when stop_on_errors is false" do
    it "processes the rest of the document after the errant closing tag" do
      source = code <<~HTML
        </head>
        <body>
        <div>
        text
        </div>
        </body>
      HTML
      expected = code <<~HTML
        </head>
        <body>
          <div>
            text
          </div>
        </body>
      HTML
      expect(described_class.beautify(source, stop_on_errors: false)).
        to eq(expected)
    end
  end
end
