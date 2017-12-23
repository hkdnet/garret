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
