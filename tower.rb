require 'pry'
require 'English'
$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
BLACK = 'x'
WHITE = 'o'
SPACE = nil
BAR = '|'

require 'tower_factory'

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
      puts "cur  : #{cur}   state: #{state.class}"
      puts "processing..."
      cur, state = state.process(@input, cur)
      raise Invalid unless state
      return true if state.done?
    end
  end
end

class StateF < State
  def done?
    true
  end
end

# BLACK = 'x'
# WHITE = 'o'
# SPACE = nil
# BAR = '|'
# TODO: rename
class Yahkuf < Tower
end
TowerFactory.build(<<-EOS.chomp, Yahkuf)
1xxR1
1ooR1
1 |L2
2XXL2
2  R6
2oXR3
2xXR4
3 oL5
3xxR3
3ooR3
3||R3
3XXR3
4 xL5
4xxR3
4ooR3
4||R3
4XXR3
5xxL5
5ooL5
5||L2
6XXR6
6| RF
EOS

Yahkuf.new(DATA.read.chomp)
__END__
x
