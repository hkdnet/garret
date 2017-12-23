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

