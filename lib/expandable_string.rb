class ExpandableString
  def initialize(str)
    @positive_str = str
  end

  def [](cur)
    @positive_str[cur]
  end

  def []=(cur, val)
    if cur == -1
      @positive_str = val + @positive_str
    else
      @positive_str[cur] = val
    end
  end

  def to_s
    @positive_str.to_s
  end
end

