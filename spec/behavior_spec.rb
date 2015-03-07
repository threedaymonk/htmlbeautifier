require 'htmlbeautifier'

describe HtmlBeautifier do
  it 'ignores HTML fragments in embedded ERB' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'allows < in an attribute' do
    source = code(%q(
      <div ng-show="foo < 1">
      <p>Hello</p>
      </div>
    ))
    expected = code(%q(
      <div ng-show="foo < 1">
        <p>Hello</p>
      </div>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'allows > in an attribute' do
    source = code(%q(
      <div ng-show="foo > 1">
      <p>Hello</p>
      </div>
    ))
    expected = code(%q(
      <div ng-show="foo > 1">
        <p>Hello</p>
      </div>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'indents within <script>' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'trims blank lines around scripts' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'removes trailing space from script lines' do
    source   = %Q(<script>\n  f();  \n</script>)
    expected = %Q(<script>\n  f();\n</script>)
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'leaves empty scripts as they are' do
    source = %q(<script src="/foo.js" type="text/javascript" charset="utf-8"></script>)
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'removes whitespace from script tags containing only whitespace' do
    source   = %Q(<script>\n</script>)
    expected = %Q(<script></script>)
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'ignores case of <script> tag' do
    source = code(%q(
      <SCRIPT>

      // code

      </SCRIPT>
    ))
    expected = code(%q(
      <SCRIPT>
        // code
      </SCRIPT>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'indents within <style>' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'trims blank lines around styles' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'removes trailing space from style lines' do
    source   = %Q(<style>\n  .foo{ margin: 0; }  \n</style>)
    expected = %Q(<style>\n  .foo{ margin: 0; }\n</style>)
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'ignores case of <style> tag' do
    source = code(%q(
      <STYLE>

      .foo{ margin: 0; }

      </STYLE>
    ))
    expected = code(%q(
      <STYLE>
        .foo{ margin: 0; }
      </STYLE>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'indents <div>s containing standalone elements' do
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
    expected = code(%q(
      <div>
        <div>
          <img src="foo" alt="" />
        </div>
        <div>
          <img src="foo" alt="" />
        </div>
      </div>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'does not break line on embedded code within <script> opening tag' do
    source = '<script src="<%= path %>" type="text/javascript"></script>'
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'does not break line on embedded code within normal element' do
    source = '<img src="<%= path %>" alt="foo" />'
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'outdents else' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'indents with hyphenated ERB tags' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'does not indent after comments' do
    source = code(%q(
      <!-- This is a comment -->
      <!-- So is this -->
    ))
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'does not indent one-line IE conditional comments' do
    source = code(%q(
      <!--[if lt IE 7]><html lang="en-us" class="ie6"><![endif]-->
      <!--[if IE 7]><html lang="en-us" class="ie7"><![endif]-->
      <!--[if IE 8]><html lang="en-us" class="ie8"><![endif]-->
      <!--[if gt IE 8]><!--><html lang="en-us"><!--<![endif]-->
        <body>
        </body>
      </html>
    ))
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'indents inside IE conditional comments' do
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
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'does not indent after doctype' do
    source = code(%q(
      <!DOCTYPE html>
      <html>
      </html>
    ))
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'does not indent after void HTML elements' do
    source = code(%q(
      <meta>
      <input id="id">
      <br>
    ))
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'ignores case of void elements' do
    source = code(%q(
      <META>
      <INPUT id="id">
      <BR>
    ))
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'does not treat <colgroup> as standalone' do
    source = code(%q(
      <colgroup>
        <col style="width: 50%;">
      </colgroup>
    ))
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'does not modify content of <pre>' do
    source = code(%q(
      <div>
        <pre>   Preformatted   text

                should  <em>not  be </em>
                      modified,
                ever!

        </pre>
      </div>
    ))
    expect(described_class.beautify(source)).to eq(source)
  end

  it 'adds a single newline after block elements' do
    source = code(%q(
      <section><h1>Title</h1><p>Lorem <em>ipsum</em></p>
      <ol>
        <li>First</li><li>Second</li></ol>


      </section>
    ))
    expected = code(%(
      <section>
        <h1>Title</h1>
        <p>Lorem <em>ipsum</em></p>
        <ol>
          <li>First</li>
          <li>Second</li>
        </ol>
      </section>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'adds newlines around <pre>' do
    source = %(<section><pre>puts "Allons-y!"</pre></section>)
    expected = code(%(
      <section>
        <pre>puts "Allons-y!"</pre>
      </section>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end

  it 'adds newline after <br>' do
    source = %(<p>Lorem ipsum<br>dolor sit<br />amet,<br/>consectetur.</p>)
    expected = code(%(
      <p>Lorem ipsum<br>
        dolor sit<br />
        amet,<br/>
        consectetur.</p>
    ))
    expect(described_class.beautify(source)).to eq(expected)
  end
end
