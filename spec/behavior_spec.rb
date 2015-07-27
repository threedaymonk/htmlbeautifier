require "htmlbeautifier"

describe HtmlBeautifier do
  it "ignores HTML fragments in embedded ERB" do
    source = code <<-END
      <div>
        <%= a[:b].gsub("\n","<br />\n") %>
      </div>
    END
    expected = code <<-END
      <div>
        <%= a[:b].gsub("\n","<br />\n") %>
      </div>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "allows < in an attribute" do
    source = code <<-END
      <div ng-show="foo < 1">
      <p>Hello</p>
      </div>
    END
    expected = code <<-END
      <div ng-show="foo < 1">
        <p>Hello</p>
      </div>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "allows > in an attribute" do
    source = code <<-END
      <div ng-show="foo > 1">
      <p>Hello</p>
      </div>
    END
    expected = code <<-END
      <div ng-show="foo > 1">
        <p>Hello</p>
      </div>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "indents within <script>" do
    source = code <<-END
      <script>
      function(f) {
          g();
          return 42;
      }
      </script>
    END
    expected = code <<-END
      <script>
        function(f) {
            g();
            return 42;
        }
      </script>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "trims blank lines around scripts" do
    source = code <<-END
      <script>

        f();

      </script>
    END
    expected = code <<-END
      <script>
        f();
      </script>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "removes trailing space from script lines" do
    source   = "<script>\n  f();  \n</script>"
    expected = "<script>\n  f();\n</script>"
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "leaves empty scripts as they are" do
    source = %{<script src="/foo.js" type="text/javascript" charset="utf-8"></script>}
    expect(described_class.beautify(source)).to eq(source)
  end

  it "removes whitespace from script tags containing only whitespace" do
    source   = "<script>\n</script>"
    expected = "<script></script>"
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "ignores case of <script> tag" do
    source = code <<-END
      <SCRIPT>

      // code

      </SCRIPT>
    END
    expected = code <<-END
      <SCRIPT>
        // code
      </SCRIPT>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "indents within <style>" do
    source = code <<-END
      <style>
      .foo{ margin: 0; }
      .bar{
        padding: 0;
        margin: 0;
      }
      </style>
    END
    expected = code <<-END
      <style>
        .foo{ margin: 0; }
        .bar{
          padding: 0;
          margin: 0;
        }
      </style>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "trims blank lines around styles" do
    source = code <<-END
      <style>

        .foo{ margin: 0; }

      </style>
    END
    expected = code <<-END
      <style>
        .foo{ margin: 0; }
      </style>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "removes trailing space from style lines" do
    source   = "<style>\n  .foo{ margin: 0; }  \n</style>"
    expected = "<style>\n  .foo{ margin: 0; }\n</style>"
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "ignores case of <style> tag" do
    source = code <<-END
      <STYLE>

      .foo{ margin: 0; }

      </STYLE>
    END
    expected = code <<-END
      <STYLE>
        .foo{ margin: 0; }
      </STYLE>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "indents <div>s containing standalone elements" do
    source = code <<-END
      <div>
      <div>
      <img src="foo" alt="" />
      </div>
      <div>
      <img src="foo" alt="" />
      </div>
      </div>
    END
    expected = code <<-END
      <div>
        <div>
          <img src="foo" alt="" />
        </div>
        <div>
          <img src="foo" alt="" />
        </div>
      </div>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "does not break line on embedded code within <script> opening tag" do
    source = %{<script src="<%= path %>" type="text/javascript"></script>}
    expect(described_class.beautify(source)).to eq(source)
  end

  it "does not break line on embedded code within normal element" do
    source = %{<img src="<%= path %>" alt="foo" />}
    expect(described_class.beautify(source)).to eq(source)
  end

  it "outdents else" do
    source = code <<-END
      <% if @x %>
      Foo
      <% else %>
      Bar
      <% end %>
    END
    expected = code <<-END
      <% if @x %>
        Foo
      <% else %>
        Bar
      <% end %>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "indents with hyphenated ERB tags" do
    source = code <<-END
      <%- if @x -%>
      <%- @ys.each do |y| -%>
      <p>Foo</p>
      <%- end -%>
      <%- elsif @z -%>
      <hr />
      <%- end -%>
    END
    expected = code <<-END
      <%- if @x -%>
        <%- @ys.each do |y| -%>
          <p>Foo</p>
        <%- end -%>
      <%- elsif @z -%>
        <hr />
      <%- end -%>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "does not indent after comments" do
    source = code <<-END
      <!-- This is a comment -->
      <!-- So is this -->
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "does not indent one-line IE conditional comments" do
    source = code <<-END
      <!--[if lt IE 7]><html lang="en-us" class="ie6"><![endif]-->
      <!--[if IE 7]><html lang="en-us" class="ie7"><![endif]-->
      <!--[if IE 8]><html lang="en-us" class="ie8"><![endif]-->
      <!--[if gt IE 8]><!--><html lang="en-us"><!--<![endif]-->
        <body>
        </body>
      </html>
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "indents inside IE conditional comments" do
    source = code <<-END
      <!--[if IE 6]>
      <link rel="stylesheet" href="/stylesheets/ie6.css" type="text/css" />
      <![endif]-->
      <!--[if IE 5]>
      <link rel="stylesheet" href="/stylesheets/ie5.css" type="text/css" />
      <![endif]-->
    END
    expected = code <<-END
      <!--[if IE 6]>
        <link rel="stylesheet" href="/stylesheets/ie6.css" type="text/css" />
      <![endif]-->
      <!--[if IE 5]>
        <link rel="stylesheet" href="/stylesheets/ie5.css" type="text/css" />
      <![endif]-->
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "does not indent after doctype" do
    source = code <<-END
      <!DOCTYPE html>
      <html>
      </html>
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "does not indent after void HTML elements" do
    source = code <<-END
      <meta>
      <input id="id">
      <br>
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "ignores case of void elements" do
    source = code <<-END
      <META>
      <INPUT id="id">
      <BR>
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "does not treat <colgroup> as standalone" do
    source = code <<-END
      <colgroup>
        <col style="width: 50%;">
      </colgroup>
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "does not modify content of <pre>" do
    source = code <<-END
      <div>
        <pre>   Preformatted   text

                should  <em>not  be </em>
                      modified,
                ever!

        </pre>
      </div>
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "adds a single newline after block elements" do
    source = code <<-END
      <section><h1>Title</h1><p>Lorem <em>ipsum</em></p>
      <ol>
        <li>First</li><li>Second</li></ol>


      </section>
    END
    expected = code <<-END
      <section>
        <h1>Title</h1>
        <p>Lorem <em>ipsum</em></p>
        <ol>
          <li>First</li>
          <li>Second</li>
        </ol>
      </section>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "does not modify content of <textarea>" do
    source = code <<-END
      <div>
        <textarea>   Preformatted   text

                should  <em>not  be </em>
                      modified,
                ever!

        </textarea>
      </div>
    END
    expect(described_class.beautify(source)).to eq(source)
  end

  it "adds newlines around <pre>" do
    source = %{<section><pre>puts "Allons-y!"</pre></section>}
    expected = code <<-END
      <section>
        <pre>puts "Allons-y!"</pre>
      </section>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "adds newline after <br>" do
    source = %{<p>Lorem ipsum<br>dolor sit<br />amet,<br/>consectetur.</p>}
    expected = code <<-END
      <p>Lorem ipsum<br>
        dolor sit<br />
        amet,<br/>
        consectetur.</p>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end

  it "indents after control expressions without optional `do` keyword" do
    source = code <<-END
      <% for value in list %>
      Lorem ipsum
      <% end %>
      <% until something %>
      Lorem ipsum
      <% end %>
      <% while something_else %>
      Lorem ipsum
      <% end %>
    END
    expected = code <<-END
      <% for value in list %>
        Lorem ipsum
      <% end %>
      <% until something %>
        Lorem ipsum
      <% end %>
      <% while something_else %>
        Lorem ipsum
      <% end %>
    END
    expect(described_class.beautify(source)).to eq(expected)
  end
end
