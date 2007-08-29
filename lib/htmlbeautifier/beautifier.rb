require 'htmlbeautifier/parser'

class HtmlBeautifier
  
  RUBY_INDENT  = 
    %r{ ^ ( if | unless | while | begin | elsif )\b
      | \b ( do | \{ ) ( \s* \| [^\|]+ \| )? $
      }x
  RUBY_OUTDENT = 
    %r{ ^ ( end | elsif |\} ) \b 
      }x
  
  def initialize(output)
    @level = 0
    @new_line = true
    self.tab_stops = 2
    @output = output
  end
  
  def tab_stops=(n)
    @tab = ' ' * n
  end
  
  def indent
    @level += 1
  end
  
  def outdent
    @level -= 1
  end
  
  def emit(s)
    if (@new_line)
      @output << (@tab * @level)
    end
    @output << s
    @new_line = false
  end
  
  def whitespace(*x)
    emit "\n"
    @new_line = true
  end
  
  def embed(e)
    lines = e.gsub(/\A<%|%>\Z/, '').split(/\n/).map{ |l| l.strip }
    outdent if lines.first =~ RUBY_OUTDENT
    emit e
    indent if lines.last =~ RUBY_INDENT
  end
  
  def directive(e)
    emit e
  end
  
  def element(e)
    emit e
  end
  
  def verbatim(s)
    emit s
  end
  
  def close_element(e)
    outdent
    if @level < 0
      puts 'error outdenting'
      puts e
    end
    emit e
  end
  
  def open_element(e)
    emit e
    indent
  end
  
  def text(t)
    emit(t.strip)
    if t =~ /\s+$/
      whitespace
    end
  end
  
  def scan(html)
    html = html.strip.gsub(/\t/, @tab)
    parser = Parser.new do
      map %r{<%.*?%>}m,               :embed
      map %r{<!.*?>}m,                :directive
      map %r{<script\b.*?</script>}m, :verbatim
      map %r{<style\b.*?</style>}m,   :verbatim
      map %r{<!--.*?-->}m,            :verbatim
      map %r{</.*?>}m,                :close_element
      map %r{<.*?/>}m,                :element
      map %r{<.*?>}m,                 :open_element
      map %r{\s+},                    :whitespace
      map %r{[^<]+},                  :text
    end
    parser.scan(html, self)
  end
end
