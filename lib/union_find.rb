class UF
  def initialize(size)
    @arr = [-1] * size
  end
  def unite(a, b)
    ra = root a
    rb = root b
    return if ra == rb
    @arr[rb] += @arr[ra]
    @arr[ra] = rb
  end
  def root(a)
    return a if @arr[a] < 0
    @arr[a] = root @arr[a]
  end
  def roots
    (0...@arr.size).select { @arr[_1] < 0 }
  end
  def size(a)
    -@arr[root a]
  end
  def same?(a, b)
    root(a) == root(b)
  end
end

# test
uf = UF.new 1000
values = 1000.times.to_a
a = values.sample 200
b = (values - a).sample 300
c = (values - a - b).shuffle
[a, b, c].each do |group|
  (1...group.size).each do |i|
    uf.unite group[i], group[rand(i)]
  end
end
raise unless uf.roots.map {|r| uf.size(r) }.sort == [200, 300, 500]
raise unless [a, b, c].all? do |group|
  group.size.times.all? { uf.same? group.sample, group.sample }
end
raise if uf.same? a.sample, b.sample
raise if uf.same? b.sample, c.sample
raise if uf.same? c.sample, a.sample
raise unless [a, b, c].map { uf.size(_1.sample) } == [200, 300, 500]
