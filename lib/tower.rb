class Tower
  class Invalid < StandardError; end

  def initialize(input)
    @input = ExpandableString.new(input.dup)
    process
  end

  def process
    cur = 0
    state = initial_state
    loop do
      puts "str: #{@input}"
      puts "cur: #{cur}   state: #{state.class}"
      puts "processing..."
      cur, state = state.process(@input, cur)
      raise Invalid unless state
      return true if state.done?
    end
  end
end

