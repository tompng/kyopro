class Matching
  def initialize(n, m)
    @n = n
    @m = m
    @paths = Array.new(n) { {} }
    @revpath = [nil] * m
  end

  def add(from, to)
    @paths[from][to] = true
  end

  def dfs(i)
    @a_visited[i] = true
    pathi = @paths[i]
    l = @a_levels[i]
    pathi.keys.each do |j|
      l2 = @b_levels[j]
      next if @b_visited[j] || l2 <= l
      @b_visited[j] = true
      k = @revpath[j]
      next if k && @a_levels[k] <= l2
      pathi.delete j
      @revpath[j] = i
      return true unless k
      pathk = @paths[k]
      unless @a_visited[k]
        pathk[j] = true
        return true if dfs k
        pathk.delete j
      end
      @revpath[j] = k
      pathi[j] = true
    end
    false
  end

  def bfs(nodes)
    a_levels = @a_levels = []
    b_levels = @b_levels = []
    paths = @paths
    revpath = @revpath
    nodes.each { a_levels[_1] = 0 }
    cangoal = false
    level = 1
    until nodes.empty?
      nodes2 = []
      level2 = level + 1
      nodes.each do |i|
        paths[i].each_key do |j|
          next if b_levels[j]
          b_levels[j] = level
          k = revpath[j]
          if k
            nodes2 << k
            a_levels[k] = level2
          else
            cangoal = true
          end
        end
      end
      nodes = nodes2
      level += 2
    end
    cangoal
  end

  def calc
    nodes = @n.times.to_a
    while true
      a = bfs nodes
      break unless a
      @a_visited = {}
      @b_visited = {}
      nodes.reject! { dfs _1 }
    end
    matching = [nil] * @n
    @revpath.each_with_index { matching[_1] = _2 if _1 }
    matching
  end
end


# m=Matching.new 10,10
# 4.times{m.add _1,_1;m.add _1,_1+1}
# m.add 4, 0
# nodes=10.times.to_a

N = 100
srand 4
M = N*N
m=Matching.new M, M
M.times{|i|
  i = (i + 12345) * 331 % M
  x, y = i.divmod N
  ja = rand(9)
  jb = [1,2,4,5,7,8].sample
  9.times do |j|
    j = (j+ja)*jb%9
    next if j == 4
    dx = j/3-1
    dy = j%3-1
    x2=x+dx+1
    y2=y+dy+1
    if 0<=x2&&x2<N&&0<=y2&&y2<N
      j=(x2*N+y2+7153) * 193 % M
      m.add i, j
    end
  end
}
# binding.irb
m.calc
