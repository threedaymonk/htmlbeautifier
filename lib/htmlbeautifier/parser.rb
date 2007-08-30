class Parser
  
  def self.debug_block(&blk)
    @debug_block = blk
  end
  
  def self.debug(match, method)
    if @debug_block
      @debug_block.call(match, method)
    end
  end
  
  def initialize(&blk)
    @maps = []
    if block_given?
      self.instance_eval(&blk)
    end
  end
  
  def map(pattern, method)
    @maps << [pattern, method]
  end
  
  def scan(subject, receiver)
    pattern = %r{ #{ @maps.map{ |p,m| p }.join('|') } }x
    subject.scan(pattern) do |match|
      dispatch(match, receiver)
    end
  end
  
  def dispatch(match, receiver)
    @maps.each do |pattern, method|
      if match.match(%r{ \A #{pattern} }x)
        self.class.debug(match, method)
        receiver.__send__(method, match)
        return
      end
    end
    raise "Unmatched sequence #{match.inspect}"
  end
  
end
