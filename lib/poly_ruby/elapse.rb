class Elapse
  Times = if defined? Process.times then Process else Time end

  def initialize
    @markPt = []
    if defined? yield then time; end
  end

  def mark(n = -1)
    if 0 > n then n = @markPt.size; end
    @markPt[n] = Float(Times.times[0])
    return n
  end

  def to_f(startPt = -2, endPt = -1)
    return @markPt[endPt] - @markPt[startPt]
  end

  def elapse(startPt = -2, endPt = -1)
    return to_f(startPt, endPt)
  end

  def to_s(startPt = -2, endPt = -1)
    return to_f(startPt, endPt).to_s
  end

  def print(startPt = -2, endPt = -1)
    printf "Elapsed_time: %f\n", to_s(startPt, endPt)
  end

  def time # for block
    mark; yield; mark
  end

  def Elapse::time
    t = new; t.mark; yield; t.mark; return t
  end
end
