class PQ
  def initialize
    clear
  end

  def clear
    @heap = [nil]
  end

  def enq(value)
    @heap << value
    up_heap(@heap.size - 1)
    self
  end

  def up_heap(i)
    value = @heap[i]
    while i > 1
      j = i / 2
      parent = @heap[j]
      break if parent <= value
      @heap[i] = parent
      i = j
    end
    @heap[i] = value
  end

  def down_heap(i)
    value = @heap[i]
    while true
      j = 2 * i
      k = j + 1
      break unless @heap[j]
      l = !@heap[k] || @heap[j] < @heap[k] ? j : k
      cvalue = @heap[l]
      break if cvalue >= value
      @heap[i] = cvalue
      i = l
    end
    @heap[i] = value
  end

  def top
    @heap[1]
  end

  def deq
    value = @heap[1]
    if @heap.size <= 2
      @heap = [nil]
    else
      @heap[1] = @heap.pop
      down_heap 1
    end
    value
  end

  def size
    @heap.size - 1
  end

  alias first top
  alias << enq
end

# TEST
pq = PQ.new
1000.times { pq << rand(500) << rand(500); pq.deq }
values = pq.size.times.map { pq.deq }
p values.sort == values
100.times { pq << (_1 + 1) * 37 % 100 }
100.times { pq << (_1 + 1) * 19 % 100 }
p 200.times.map { pq.deq } == 200.times.to_a.map { _1 / 2 }
