require 'test/unit'
lib = File.expand_path('../../lib', __FILE__)
$:.unshift lib unless $:.include?(lib)

module HtmlBeautifierTestUtilities
  def code(str)
    str = str.gsub(/\A\n|\n\s*\Z/, '')
    indentation = str[/\A +/]
    lines = str.split(/\n/)
    lines.map{ |line| line.sub(/^#{indentation}/, '') }.join("\n")
  end

  def assert_beautifies(expected, source)
    actual = HtmlBeautifier.beautify(source)
    assert expected == actual, "Expected:\n#{expected}\nbut was:\n#{actual}"
  end
end
