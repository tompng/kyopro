class BITree
  def initialize(size)
    @level = size.bit_length
    @level -= 1 if (1 << (@level - 1)) == size
    @offset = 1 << (@level - 1)
    @size = 1 << @level
    @arr = [0] * @size
  end

  def add(i, n)
    i += @offset * 2
    while i >= 1
      f = i & 1
      i >>= 1
      @arr[i] += n if f == 0
    end
    @arr[0] += n
  end

  def sum(i)
    return @arr[0] if i >= @size
    offset = 1
    sum = 0
    l = @level
    while l > 0
      return sum if i & ((1 << l) - 1) == 0
      if i[l - 1] == 1
        v = @arr[offset + (i >> l)]
        sum += v
      end
      offset <<= 1
      l -= 1
    end
    sum
  end
end

# test
bt = BITree.new 1024
MOD = 10**9 + 7
a = 17
1024.times do |i|
  bt.add i, a.pow(i, MOD)
end
(0..1024).each do |i|
  expected = (a.pow(i, MOD) - 1) * (a - 1).pow(MOD - 2, MOD) % MOD
  raise unless bt.sum(i) % MOD == expected
end
