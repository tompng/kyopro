class PQ2
  def initialize
    clear
  end

  def clear
    @heap = [nil]
  end

  def enq(priority, value)
    index = @heap.size
    node = [priority, value, index]
    @heap << node
    up_heap index
    node
  end

  def up_heap(i)
    node = @heap[i]
    while i > 1
      j = i / 2
      parent = @heap[j]
      break if parent[0] <= node[0]
      @heap[i] = parent
      parent[2] = i
      i = j
    end
    @heap[i] = node
    node[2] = i
  end

  def down_heap(i)
    node = @heap[i]
    while true
      j = 2 * i
      k = j + 1
      break unless @heap[j]
      l = !@heap[k] || @heap[j][0] < @heap[k][0] ? j : k
      cnode = @heap[l]
      break if cnode[0] >= node[0]
      @heap[i] = cnode
      cnode[2] = i
      i = l
    end
    @heap[i] = node
    node[2] = i
  end

  def update(index, priority)
    node = @heap[index]
    prev = node[0]
    node[0] = priority
    if prev < priority
      down_heap index
    else
      up_heap index
    end
  end

  def top
    @heap[1]
  end

  def deq
    node = @heap[1]
    return unless node
    if @heap.size <= 2
      @heap = [nil]
    else
      @heap[1] = @heap.pop
      down_heap 1
    end
    node.pop
    node
  end

  def size
    @heap.size - 1
  end

  alias first top
end

# TEST
pq = PQ2.new
nodes = 100.times.map do
  n = (_1 + 1) * 37 % 100
  pq.enq rand(100), n.to_s
end
nodes.shuffle.each { pq.update _3, _2.to_i }
p pq.size.times.map { pq.deq } == 100.times.map { [_1, _1.to_s] }
1000.times { pq.enq rand(500), nil; pq.enq rand(500), nil; pq.deq }
values = pq.size.times.map { pq.deq[0] }
p values.sort == values
