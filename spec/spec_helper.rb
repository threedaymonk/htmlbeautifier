module HtmlBeautifierSpecUtilities
  def code(str)
    str = str.gsub(/\A\n|\n\s*\Z/, "")
    indentation = str[/\A +/]
    lines = str.split(/\n/)
    lines.map{ |line| line.sub(/^#{indentation}/, "") }.join("\n")
  end
end

RSpec.configure do |config|
  config.include HtmlBeautifierSpecUtilities
end
