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
