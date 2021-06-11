require "htmlformatter"

describe HtmlFormatter do
  it "ignores HTML fragments in embedded EEX" do
    source = code <<-END
      <div>
        <%= Module.func("\n","<br />\n") %>
      </div>
    END
    expected = code <<-END
      <div>
        <%= Module.func("\n","<br />\n") %>
      </div>
    END
    expect(described_class.format(source, {engine: "eex"})).to eq(expected)
  end

  it "does not break line on embedded code within <script> opening tag" do
    source = %{<script src="<%= path %>" type="text/javascript"></script>}
    expect(described_class.format(source, {engine: "eex"})).to eq(source)
  end

  it "does not break line on embedded code within normal element" do
    source = %{<img src="<%= path %>" alt="foo" />}
    expect(described_class.format(source, {engine: "eex"})).to eq(source)
  end

  it "outdents else" do
    source = code <<-END
      <%= if @x do %>
      Foo
      <% else %>
      Bar
      <% end %>
    END
    expected = code <<-END
      <%= if @x do %>
        Foo
      <% else %>
        Bar
      <% end %>
    END
    expect(described_class.format(source, {engine: "eex"})).to eq(expected)
  end

  it "keeps multiline indentations" do
    source = code <<-END
      <div><div>
      <%= select f, :sort_by, [
            {"Account Created Date", :account_created_date},
            {"Last Name", :last_name},
            {"Email", :email},
          ] %>
      </div></div>
    END
    expected = code <<-END
      <div>
        <div>
          <%= select f, :sort_by, [
            {"Account Created Date", :account_created_date},
            {"Last Name", :last_name},
            {"Email", :email},
          ] %>
        </div>
      </div>
    END
    expect(described_class.format(source, {engine: "eex"})).to eq(expected)
  end
end
