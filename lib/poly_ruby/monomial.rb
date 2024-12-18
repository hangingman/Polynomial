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
#        t= :lex(default), :deglex,  :degrevlex
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
  Monomial.new(c, p)
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
    m = Monomial.new(@coeff, @power.clone)
    m
  end

  def ==(other)
    case other
    when Monomial
      self.coeff == other.coeff && self.power == other.power
    else
      raise TypeError
    end
  end

  def normalize!
    @power.each { |v, p| if 0 == p; @power.delete(v); end }
  end

  def to_s(format = "text")
    case format
    when "text"
      timeC = ""
      timeV = "*"
      power1 = "^("
      power2 = ")"
      ms = ""
      me = ""
    when "tex"
      timeC = ""
      timeV = ""
      power1 = "^{"
      power2 = "}"
      ms = ""
      me = ""
    when "texm"
      timeC = ""
      timeV = ""
      power1 = "^{"
      power2 = "}"
      ms = "$"
      me = "$"
    when "prog"
      timeC = "*"
      timeV = "*"
      power1 = "**("
      power2 = ")"
      ms = ""
      me = ""
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
      den = "/" + c.denominator.to_s
      c = c.numerator
    else
      den = ""
    end
    vs = ""
    ts = ""
    VarOrder.each { |v|
      d = @power[v]
      if d != 0
        vs = vs + ts + v
        ts = timeV
        if d > 1; vs = vs + power1 + d.to_s + power2; end       end
    }
    str = sign
    if (c != 1) || (vs == ""); str = str + c.to_s; end
    if (c != 1) && (vs != ""); str = str + timeC; end
    str = str + vs + den
    ms + str + me
  end

  def power_product
    m = Monomial.new(1, @power)
    m
  end

  def lcm(other) # lcm of power product
    m = Monomial.new(1, {})
    lhs_power = @power.dup
    rhs_power = other.power.dup
    var_order = lhs_power.keys.concat(rhs_power.keys.dup).uniq

    var_order.each { |v|
      d = [power[v], other.power[v]].max
      m.power[v] = d
    }
    m
  end

  def gcd(other) # gcd of power product
    m = Monomial.new(1, {})
    VarOrder.each { |v|
      d = [@power[v], other.power[v]].min
      m.power[v] = d
    }
    m
  end

  def -@
    Monomial.new(-@coeff, @power)
  end

  def negate!
    @coeff = -@coeff
    self
  end

  # Assume that power is the same.
  def +(m)
    if m.kind_of?(Monomial) && (0 == (self <=> m))
      Monomial.new(@coeff + m.coeff, @power)
    elsif m.kind_of?(Monomial) || M.kind_of?(Numeric)
      PolynomialM(self) + PolynomialM(m)
    elsif m.kind_of?(PolynomialM)
      PolynomialM(self) + m
    else
      x, y = m.coerce(self)
      x + m
    end
  end

  # Assume that power is the same.
  def -(m)
    self + (-m)
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
      s
    else
      raise TypeError
    end
  end

  def *(m)
    if m.kind_of?(Monomial)
      c = @coeff * m.coeff
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] + d }
      Monomial.new(c, p)
    elsif m.kind_of?(Numeric)
      Monomial.new(@coeff * m, @power)
    else
      x, y = m.coerce(self)
      x * m
    end
  end

  # Rational 係数で 割れるかどうかを調べる.
  def divisible?(divisor)
    if @coeff == 0; return false; end
    divisor.power.each_pair { |v, d| if @power[v] < d; return false; end }
    true
  end

  def /(m)
    if m.kind_of?(Monomial) # && self.divisible?(m);
      q = Number.divII(@coeff, m.coeff)
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] - d } # determine exponents
      Monomial.new(q, p)
    elsif m.kind_of?(Numeric)
      Monomial.new(Number.divII(@coeff, m), @power)
    else
      raise TypeError
    end
  end

  # Integer 係数の term として割れるかどうかを調べる. 係数は無視.
  def divisibleI?(divisor)
    if (0 <= @coeff) && (@coeff < divisor.coeff.abs); return false; end
    divisor.power.each_pair { |v, d| if @power[v] < d; return false; end }
    true
  end

  def divmod_i(m)
    if m.kind_of?(Monomial) # && self.divisible?(m);
      q = Number.divFloor(@coeff, m.coeff)
      r = @coeff - q * m.coeff # Note that r>=0
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] - d } # determine exponents
      [Monomial.new(q, p), Monomial.new(r, p)]
    elsif m.kind_of?(Numeric)
      q = Number.divFloor(@coeff, m)
      r = @coeff - q * m # Note that r>=0
      [Monomial.new(q, @power), Monomial.new(r, @power)]
    else
      x, y = m.coerce(self)
      x * m
      #raise TypeError
    end
  end

  def div_zp(m, prime)
    if m.kind_of?(Monomial) # && self.divisible?(m);
      q = Number.modP(@coeff * Number.inv(m.coeff, prime), prime)
      p = @power.clone
      m.power.each_pair { |v, d| p[v] = p[v] - d } # determine exponents
      Monomial.new(q, p)
    elsif m.kind_of?(Integer)
      q = Number.modP(@coeff * Number.inv(m, prime), prime)
      Monomial.new(q, @power)
    else
      raise TypeError
    end
  end

  def coerce(x)
    case x
    when Numeric; [PolynomialM(x), PolynmialM(self)]
    when Monomial; [PolynomialM(x), PolynmialM(self)]
    when Polynomial; [PolynomialM(x), PolynmialM(self)]
    when PolynomialM; [x, PolynmialM(self)]
    else
      raise TypeError
    end
  end

  ### degree & order ###

  def total_degree
    deg = 0
    @power.each_value { |d| deg = deg + d }
    deg
  end

  #  lex(lexicographical),
  #  revlex(ReverseLexicographical)
  #       Note that "revlex" is not a term order.
  #  deglex(degreeLexicographical)
  #  degrevlex(degreeReverseLexicographical)

  TermOrder = [:lex] # :lex :deglex :degrevlex

  def Monomial.set_term_order(t = :lex) # t= :lex :deglex :degrevlex
    TermOrder[0] = t
  end

  def Monomial.get_term_order
    TermOrder[0]
  end

  VarOrder0 = ["x", "y", "z", "u", "v", "w", "p", "q", "r", "s", "t"] +
              ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o"]
  VarOrder = VarOrder0.dup

  def Monomial.set_var_order(order = VarOrder0)
    VarOrder.replace(order)
  end

  def Monomial.get_var_order
    VarOrder.dup
  end

  def Monomial.append_var_name(v) # Assume that v be String
    if !VarOrder.include?(v); VarOrder.push(v); end
  end

  # lexicographic order(辞書式順序)
  #  1: self ≺ m
  #  0: self=m
  # -1: m ≺ self
  #
  #  1 ≺ y ≺ y^2 ≺ ... ≺ x ≺ xy ≺ xy^2 ≺ ... x^2 ≺ x^2y ≺ ... x^3 ...
  def lex(m)
    ret = 0
    lhs = @power
    rhs = m.power
    for var in VarOrder
      if lhs[var].to_i - rhs[var].to_i != 0
        ret = lhs[var].to_i <=> rhs[var].to_i
        break
      end
    end
    ret
  end

  # reverse lexicographic order(逆辞書式順序)
  #  1: self ≺ m
  #  0: self=m
  # -1: m ≺ self
  def revlex(m)
    ret = 0
    lhs = @power
    rhs = m.power
    for var in VarOrder.reverse
      if lhs[var].to_i - rhs[var].to_i != 0
        ret = -(lhs[var].to_i <=> rhs[var].to_i)
        break
      end
    end
    ret
  end

  # degree lexicographic order(全次数辞書式順序)
  #  1: self ≺ m
  #  0: self=m
  # -1: m ≺ self
  def deglex(m)
    t1 = self.total_degree
    t2 = m.total_degree
    if t1 != t2; return t1 <=> t2; end
    self.lex(m)
  end

  # degree reverse lexicographic order(全次数逆辞書式順序)
  #  1: self ≺ m
  #  0: self=m
  # -1: m ≺ self
  def degrevlex(m)
    t1 = self.total_degree
    t2 = m.total_degree
    if t1 != t2; return t1 <=> t2; end
    self.revlex(m)
  end

  #  1: self ≺ m; self > m
  #  0: self=m  ; self ==m
  # -1: m ≺ self; self < m
  def <=>(m, term_order=:lex)
    case term_order
    when :lex
      self.lex(m)
    when :deglex
      self.deglex(m)
    when :degrevlex
      self.degrevlex(m)
    end
  end

  def inspect
    "Monomial(@coeff=#{@coeff}, @power=#{@power})"
  end
end # Monomial
