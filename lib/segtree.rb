class SegTree
  def initialize(size, &block)
    @level = size.bit_length
    @level -= 1 if (1 << (@level - 1)) == size
    @size = 1 << @level
    @offset = @size
    @arr = [0] * 2 * @size
    @mask = @size - 1
    @block = block
  end
  def [](i)
    @arr[@offset + i]
  end
  def []=(i, n)
    i += @offset
    while i > 1
      return if @arr[i] == n
      @arr[i] = n
      m = @arr[i ^ 1]
      n = n + m
      i >>= 1
    end
    @arr[i] = n
  end
  def get(i, j)
    i += @offset
    j += @offset
    l = @level - 1
    return @arr[i] if i == j
    l -= 1 while i[l] == j[l]
    mask = (1 << l) - 1
    n = getl i, l
    m = getr j, l
    @block.call getl(i, l), getr(j, l)
  end
  def getl(i, l)
    mask = (1 << l) - 1
    n = 0
    return @block.call @arr[i >> (l + 1)], n if i == @offset
    while l >= 0
      return @block.call @arr[i >> l], n if i & mask == 0
      p [i, @arr[(i >> l) + 1]] if i[l] == 0
      n = @block.call @arr[(i >> l) + 1], n if i[l] == 0
      mask >>= 1
      l -= 1
    end
    n
  end
  def getr(i, l)
    n = 0
    while l >= 0
      if i & 1 == 1
        m = @arr[i - 1]
        n = n + m
      end
      i = (i + lr) >> 1
      l -= 1
    end
    n
  end
end

t = SegTree.new(1024){_1+_2}
1024.times do
  t[_1] = 1
end
t.instance_eval{
  i=1024+7
  n=0
  l=8
  mask=(1<<l)-1
  binding.irb
}