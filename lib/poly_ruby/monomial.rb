# coding: utf-8
# Monomial : monomial class of multi variable
#
############################################
# by toyofuku@juice.or.jp, 3 Feb 2000
#   Idea of "P_.x"
# K.Kodama(kodama@kobe-kosen.ac.jp) 2000-01-30
#   first(experimental) version
#
# This module is distributed freely in the sence of
# GPL(GNU General Public License).
############################################
#
# class Monomial
# Monomial(c,p)
#    generate new Monomial
#    c be coefficient
#    p be Hash of "var"=>power
#    Recommended than new, beacuse checking var names.
# Monomial.new(c,p)
#     generate new Monomial
#     c be coefficient
#     p be Hash of "var"=>power
# normalize!
# to_s(format)
#       format: "text" then "5x^4+3x^2+1"  (default)
#               "tex"       "5x^{4}+3x^{2}+1"
#               "texm"      "$5x^{4}+3x^{2}+1$"
#               "prog"      "5*x**4+3*x**2+1"
# Monomial.set_term_order(t)
# Monomial.get_term_order
#        t= "lex"(default), "deglex",  "degrevlex"
#        set/get term order
# Monomial.set_var_order(order)
# Monomial.get_var_order
# Monomial.append_var_name(v) # Assume that v be String
#     set/get/append var. order
#     default VarOrder is:
#     ["x","y","z","u","v","w","p","q","r","s","t",
#     "a","b","c","d","e","f","g","h","i","j","k","l","m","n","o"]
# power_product
# lcm(other)    lcm of power product
# gcd(other) # gcd of power product
# +,-        needed have same power product
# *
# -@
#     return -self
# divisible?(other)
# /(monomial)
#       divide.  Assume self.divisible?(other)
# divmod_i(m)
#       divide.  Assume self.divisible?(other)
#       return quotient, residue
#       quotient has Integer coefficient, residue>=0
# div_zp(m,p)
#       divide.  Assume self.divisible?(other)
# total_degree
# <=>
#       1: self>m, 0: self=m, -1: self<m
# lex(m),revlex(m),deglex(m),degrevlex(m)
#        Note that revlex is not a term order.
#
#####################################

def Monomial(c = 0, p = {}) # coefficient and power product
  p.each_key { |v| Monomial.append_var_name(v) }
  return Monomial.new(c, p)
end

class Monomial

  # c: coefficient, p: hash of pair "variable"=>degree
  def initialize(c = 0, p = {})
    @coeff = c
    @power = Hash.new(0)
    p.each_pair { |k, v| @power[k] = v } # @power.replace(p)
  end

  attr_accessor :coeff
  attr_accessor :power

  def clone
    m = Monomial.new(@coeff, @power.clone); return m
  end

  def ==(other)
    case other
    when Monomial
      return self.coeff == other.coeff && self.power == other.power
    else
      raise TypeError
    end
  end

  def normalize!
    @power.each { |v, p| if 0 == p; @power.delete(v); end }
  end

  def to_s(format = "text")
    case format
    when "text"; timeC = ""; timeV = "*"; power1 = "^("; power2 = ")"; ms = ""; me = ""
    when "tex"; timeC = ""; timeV = ""; power1 = "^{"; power2 = "}"; ms = ""; me = ""
    when "texm"; timeC = ""; timeV = ""; power1 = "^{"; power2 = "}"; ms = "$"; me = "$"
    when "prog"; timeC = "*"; timeV = "*"; power1 = "**("; power2 = ")"; ms = ""; me = ""
    end
    # timeC: 係数と変数間の記号
    # timeV: 変数間の分離記号
    # power1, power2: 指数部の開始と終了
    # ms,me: 数式全体のくくり
    c = @coeff
    if c < 0
      sign = "-"
      c = -c
    else
      sign = ""
    end
    if c.kind_of?(Rational) && (c.denominator != 1)
      den = "/" + c.denominator.to_s; c = c.numerator
    else
      den = ""
    end
    vs = ""; ts = ""
    VarOrder.each { |v|
      d = @power[v]
      if d != 0; vs = vs + ts + v; ts = timeV
        if d > 1; vs = vs + power1 + d.to_s + power2; end       end
    }
    str = sign
    if (c != 1) || (vs == ""); str = str + c.to_s; end
    if (c != 1) && (vs != ""); str = str + timeC; end
    str = str + vs + den
    return ms + str + me
  end

  def power_product
    m = Monomial.new(1, @power); return m
  end

  def lcm(other) # lcm of power product
    m = Monomial.new(1, {})
    VarOrder.each { |v|
      d = [@power[v], other.power[v]].max
      #if m != nil
      m.power[v] = d
      #end
    }
    return m
  end

  def gcd(other) # gcd of power product
    m = Monomial.new(1, {})
    VarOrder.each { |v|
      d = [@power[v], other.power[v]].min
      #if m != 0
      m.power[v] = d
      #end
    }
    return m
  end

  def -@
    return Monomial.new(-@coeff, @power)
  end

  def negate!
    @coeff = -@coeff; return self
  end

  # Assume that power is the same.
  def +(m)
    if m.kind_of?(Monomial) && (0 == (self <=> m))
      return Monomial.new(@coeff + m.coeff, @power)
    elsif m.kind_of?(Monomial) || M.kind_of?(Numeric)
      return PolynomialM(self) + PolynomialM(other)
    elsif m.kind_of?(PolynomialM)
      return PolynomialM(self) + other
    else
      x, y = m.coerce(self)
      return x + m
    end
  end

  # Assume that power is the same.
  def -(m)
    return self + (-m)
  end

  def **(n)
    if n.kind_of?(Integer)
      s = Monomial.new(1, {})
      p = self.clone
      p.normalize!
      while n > 0
        if n & 1 == 1
          s = s * p
        end
        p = p * p
        n >>= 1
      end
      return s
    else
      raise TypeError
    end
  end

  def *(m)
    if m.kind_of?(Monomial)
      c = @coeff * m.coeff
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] + d }
      return Monomial.new(c, p)
    elsif m.kind_of?(Numeric)
      return Monomial.new(@coeff * m, @power)
    else
      x, y = m.coerce(self)
      return x * m
    end
  end

  # Rational 係数で 割れるかどうかを調べる.
  def divisible?(divisor)
    if @coeff == 0; return false; end
    divisor.power.each_pair { |v, d| if @power[v] < d; return false; end }
    return true
  end

  def /(m)
    if m.kind_of?(Monomial) # && self.divisible?(m);
      q = Number.divII(@coeff, m.coeff)
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] - d } # determine exponents
      return Monomial.new(q, p)
    elsif m.kind_of?(Numeric)
      return Monomial.new(Number.divII(@coeff, m), @power)
    else
      raise TypeError
    end
  end

  # Integer 係数の term として割れるかどうかを調べる. 係数は無視.
  def divisibleI?(divisor)
    if (0 <= @coeff) && (@coeff < divisor.coeff.abs); return false; end
    divisor.power.each_pair { |v, d| if @power[v] < d; return false; end }
    return true
  end

  def divmod_i(m)
    if m.kind_of?(Monomial) # && self.divisible?(m);
      q = Number.divFloor(@coeff, m.coeff)
      r = @coeff - q * m.coeff # Note that r>=0
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] - d } # determine exponents
      return Monomial.new(q, p), Monomial.new(r, p)
    elsif m.kind_of?(Numeric)
      q = Number.divFloor(@coeff, m)
      r = @coeff - q * m # Note that r>=0
      return Monomial.new(q, @power), Monomial.new(r, @power)
    else
      x, y = m.coerce(self)
      return x * m
      #raise TypeError
    end
  end

  def div_zp(m, prime)
    if m.kind_of?(Monomial) # && self.divisible?(m);
      q = Number.modP(@coeff * Number.inv(m.coeff, prime), prime)
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] - d } # determine exponents
      return Monomial.new(q, p)
    elsif m.kind_of?(Integer)
      q = Number.modP(@coeff * Number.inv(m, prime), prime)
      return Monomial.new(q, @power)
    else
      raise TypeError
    end
  end

  def coerce(x)
    case x
    when Numeric; return PolynomialM(x), PolynmialM(self)
    when Monomial; return PolynomialM(x), PolynmialM(self)
    when Polynomial; return PolynomialM(x), PolynmialM(self)
    when PolynomialM; return x, PolynmialM(self)
    else
      raise TypeError
    end
  end

  ### degree & order ###

  def total_degree
    deg = 0
    @power.each_value { |d| deg = deg + d }
    return deg
  end

  #  lex(lexicographical),
  #  revlex(ReverseLexicographical)
  #       Note that "revlex" is not a term order.
  #  deglex(degreeLexicographical)
  #  degrevlex(degreeReverseLexicographical)

  TermOrder = ["lex"] # "lex" "deglex" "degrevlex"

  def Monomial.set_term_order(t = "lex") # t= "lex" "deglex" "degrevlex"
    TermOrder[0] = t
  end

  def Monomial.get_term_order
    return TermOrder[0]
  end

  VarOrder0 = ["x", "y", "z", "u", "v", "w", "p", "q", "r", "s", "t"] +
              ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o"]
  VarOrder = VarOrder0.dup

  def Monomial.set_var_order(order = VarOrder0)
    VarOrder.replace(order)
  end

  def Monomial.get_var_order
    return VarOrder.dup
  end

  def Monomial.append_var_name(v) # Assume that v be String
    if !VarOrder.include?(v); VarOrder.push(v); end
  end

  def lex(m) #lexical order
    for i in 0..VarOrder.size - 1
      if @power[VarOrder[i]] != m.power[VarOrder[i]]
        return @power[VarOrder[i]] <=> m.power[VarOrder[i]]
      end
    end
    return 0
  end

  def revlex(m)
    i = VarOrder.size - 1
    while i >= 0
      if @power[VarOrder[i]] != m.power[VarOrder[i]]
        return -(@power[VarOrder[i]] <=> m.power[VarOrder[i]])
      end
      i = i - 1
    end
    return 0
  end

  def deglex(m)
    t1 = self.total_degree; t2 = m.total_degree
    if t1 != t2; return t1 <=> t2; end
    return self.lex(m)
  end

  def degrevlex(m)
    t1 = self.total_degree; t2 = m.total_degree
    if t1 != t2; return t1 <=> t2; end
    return self.revlex(m)
  end

  # 1: self>m, 0: self=m, -1: self<m
  def <=>(m)
    case TermOrder[0]
    when "lex"; return self.lex(m)
    when "deglex"; return self.deglex(m)
    when "degrevlex"; return self.degrevlex(m)
    end
  end
end # Monomial
