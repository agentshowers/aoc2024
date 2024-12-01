module Utils
  def sum(a, b)
    a + b
  end

  def insert_sort(list, n)
    insert_at = list.bsearch_index { |x| x >= n }
    insert_at ||= list.length
    list.insert(insert_at, n)
  end
end