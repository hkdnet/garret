require 'pry'
BLACK = 'x'
WHITE = 'o'
SPACE = nil
BAR = '|'

class ExpandableString
  def initialize(str)
    @str = str
  end

  def [](cur)
    @str[cur]
  end

  def []=(cur, val)
    if cur == -1
      @str = val + @str
    else
      @str[cur] = val
    end
  end

  def to_s
    @str.to_s
  end
end

class State
  def process(input, cur)
    raise NotImplementedError
  end

  def done?
    false
  end
end

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
      puts "str  : #{@input}"
      puts "cur  : #{cur}"
      puts "state: #{state.class}"
      puts "processing..."
      cur, state = state.process(@input, cur)
      raise Invalid unless state
      return true if state.done?
    end
  end
end

# TODO: rename
class Yahkuf < Tower
  X = 'X'
  class State1 < State
    def process(input, cur)
      if input[cur] == BLACK || input[cur] == WHITE
        return [cur+1, self]
      end
      if input[cur] == SPACE
        input[cur] = BAR
        return [cur-1, State2.new]
      end
    end
  end
  class State2 < State
    def process(input, cur)
      if input[cur] == X
        return [cur-1, self]
      end
      if input[cur] == SPACE
        return [cur+1, State6.new]
      end
      if input[cur] == WHITE
        input[cur] = X
        return [cur+1, State3.new]
      end
      if input[cur] == BLACK
        input[cur] = X
        return [cur+1, State4.new]
      end
    end
  end
  class State3 < State
    def process(input, cur)
      if input[cur] == SPACE
        input[cur] = WHITE
        return [cur-1, State5.new]
      end
      if [WHITE, BLACK, X, BAR].include?(input[cur])
        return [cur+1, self]
      end
    end
  end
  class State4 < State
    def process(input, cur)
      if input[cur] == SPACE
        input[cur] = BLACK
        return [cur-1, State5.new]
      end
      if [WHITE, BLACK, X, BAR].include?(input[cur])
        return [cur+1, self]
      end
    end
  end
  class State5 < State
    def process(input, cur)
      if input[cur] == BLACK || input[cur] == WHITE
        return [cur-1, self]
      end
      if input[cur] == State2.new
        return [cur-1, self]
      end
    end
  end
  class State6 < State
    def process(input, cur)
      if input[cur] == X
        return [cur+1, self]
      end
      if input[cur] == BAR
        input[cur] = WHITE
        return [cur+1, State7.new]
      end
    end
  end
  class State7 < State
    def done?
      true
    end
  end

  def initial_state
    State1.new
  end
end

Yahkuf.new(DATA.read.chomp)
__END__
x
