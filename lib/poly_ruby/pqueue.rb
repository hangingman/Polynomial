# Priority queue with array based heap.
#
# This is distributed freely in the sence of
# GPL(GNU General Public License).
#
# Rick Bradley 2003/02/02 patch for Ruby 1.6.5. Thank you!
# K.Kodama 2001/03/10

class PQueue
  attr_accessor :qarray
  attr_reader :size
  attr_reader :gt

  def initialize(compareProc = lambda { |x, y| x > y })
    # By default, retrieves maximal elements first.
    @qarray = [nil]
    @size = 0
    @gt = compareProc
    make_legal
  end

  private :initialize

  def upheap(k)
    k2 = (k / 2).to_i
    v = @qarray[k]
    while ((k2 > 0) and (@gt[v, @qarray[k2]]))
      @qarray[k] = @qarray[k2]
      k = k2
      k2 = (k2 / 2).to_i
    end
    @qarray[k] = v
  end

  private :upheap

  def downheap(k)
    v = @qarray[k]
    q2 = (@size / 2).to_i
    loop {
      if (k > q2); break; end
      j = k + k
      if ((j < @size) and (@gt[@qarray[j + 1], @qarray[j]]))
        j = j + 1
      end
      if @gt[v, @qarray[j]]; break; end
      @qarray[k] = @qarray[j]
      k = j
    }
    @qarray[k] = v
  end

  private :downheap

  def make_legal
    for k in 2..@size do upheap(k); end
  end

  def empty?
    (0 == @size)
  end

  def clear
    @qarray.replace([nil])
    @size = 0
  end

  def to_a
    # array sorted as increasing order.
    res = @qarray[1..@size]
    res.sort! { |x, y| if @gt[x, y]; 1; elsif @gt[y, x]; -1; else 0; end }
    res
  end

  def replace_array(arr = [])
    @qarray.replace([nil] + arr)
    @size = arr.size
    make_legal
  end

  def clone
    q = new
    q.qarray = @qarray.clone
    q.size = @size
    q.gt = @gt
    q
  end

  def push(v)
    @size = @size + 1
    @qarray[@size] = v
    upheap(@size)
  end

  def pop
    # return top element.  nil if queue is empty.
    if @size > 0
      res = @qarray[1]
      @qarray[1] = @qarray[@size]
      @size = @size - 1
      downheap(1)
      res
    else nil     end
  end

  def top
    # top element. not destructive.
    if @size > 0; @qarray[1]; else nil; end
  end

  def replace_top_low(v)
    # replace top element if v<top element.
    if @size > 0
      @qarray[0] = v
      downheap(0)
      @qarray[0]
 else @qarray[1] = v
      nil
 end
  end

  def replace_top(v)
    # replace top element
    if @size > 0
      res = @qarray[1]
      @qarray[1] = v
      downheap(1)
      res
 else @qarray[1] = v
      nil
 end
  end

  def each_pop
    # iterate pop. destructive. Use as self.each_pop{|x| ... }.
    while (@size > 0); yield self.pop; end
  end

  def each_with_index
    # Not ordered. Use as self.each_with_index{|e,i| ... }.
    for i in 1..@size do yield @qarray[i], i; end
  end
end # class pqueue
