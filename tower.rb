require 'pry'
BLACK = 'x'
WHITE = 'o'
SPACE = nil
BAR = '|'

module TowerFactory
  Instruction = Struct.new(:id, :match, :processed, :dir, :next_id) do
    def validate!
      raise 'dir' unless dir == 'R' || dir == 'L'
    end

    def match?(c)
      return match == ' ' if c.nil?
      c == match
    end

    def step(cur)
      if dir == 'R'
        cur + 1
      else
        cur - 1
      end
    end

    def next_state_class_name
      "State#{next_id}"
    end
  end

  class << self
    # @param [String] source
    # @param [Class] namespace
    def build(source, namespace)
      h = parse(source)
      namespace.instance_exec do
        define_method(:initial_state) do
          namespace.const_get('State1').new
        end
      end
      h.each do |id, insns|
        klass = Class.new(State) do
          define_method(:process) do |input, cur|
            c = input[cur]
            insn = insns.find { |e| e.match?(c) }
            if insn.nil?
              raise "No Macth id:#{id}, #{cur} #{input}"
            end
            input[cur] = insn.processed
            next_state_class = namespace.const_get(insn.next_state_class_name, true)
            if next_state_class.nil?
              raise "missing"
            end
            [insn.step(cur), next_state_class.new]
          end
        end
        namespace.const_set("State#{id}", klass)
      end
    end

    private

    def parse(source)
      insns = source.split("\n").map do |e|
        Instruction.new(*e.chars)
      end
      insns.each(&:validate!)
      insns.group_by(&:id)
    end
  end
end

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
