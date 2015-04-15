module HtmlBeautifierSpecUtilities
  def code(str)
    str = str.gsub(%r{\A\n|\n\s*\Z}, "")
    indentation = str[%r{\A +}]
    lines = str.split(%r{\n})
    lines.map { |line| line.sub(%r{^#{indentation}}, "") }.join("\n")
  end
end

RSpec.configure do |config|
  config.include HtmlBeautifierSpecUtilities
end
