def slide_max(arr, k)
  q = []
  arr.each_with_index.map do |v, i|
    q.pop while !q.empty? && arr[q.last] <= v
    q.shift while !q.empty? && q.first <= i - k
    q << i
    arr[q.first]
  end
end
