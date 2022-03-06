# coding: utf-8
# PolynomialM : polynomial class of multi variable
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
# class PolynomialM
#
# ARITHMETIC:
# +, -, *, /, %,
# **(n)
#      "n" be Integer
# divmod(divisors)
#      divisors be Array of PolynomialM
#      return q,r
#      quotient q is Array of PolynomialM  [q1, q2,...,qn]
#      residue r is Polynomial
# divmodZp(divisors)
#      divide in Zp
# divmod_i(divisors)
#      divide in Z
#      quotient は Integer係数で得ます.
#      係数の丸めは leading term の剰余が非負になる方向に行います.
# substitute(list) # list is Hash of "var"=>val
#     value admit Integer, Rational, Float, Polynomial, PolynomialM....
#     代入は現在の式に対して一気に行います.
#     例えば:
#     f1=PolynomialM("x+y^2")
#     f2=f1.substitute("x"=>PolynomialM("y"),"y"=>PolynomialM("x"))
#     で x, y が入れ替わり x^2+y を得ます.
# derivative(vars) # vars is Array of var names
#    derivative
#    先頭の変数から順に偏微分します.
#    f.derivative(["x","x","y"])
# integral(vars)  # vars is Array of var names
#     integral
#    先頭の変数から順に積分し原始関数を求めます.
#    積分定数は考慮しません.
# lt      leading term
# lc      leading coefficient
# lp      leading power product
# coeff(var,deg) # var の多項式と見ての deg 次の係数多項式を返す.
# maxdeg(var) # var の多項式と見ての最高次数
# mindeg(var) # var の多項式と見ての最低次数
# lcm_coeff_denom
#     lcm of denominator of coefficients as Rarional
# gcd_coeff_num
#    gcd of numerator of coefficients as Rational
#
# TESTING:
# <=>
#    Now, same as self.lt<=>other.lt
# ==
# zero?
#      Is zero?
#
# CONVERTING:
# PolynomialM(arg) or PolyM(arg)
#      arg admit Numeric,String,Monomial,Polynomial
#      Recommended than new, beacuse of checking var names.
#      Use as PolynomialM("2*x+3*y**2+z*x")
#      Note that "xy" means name xy, not x*y.
#      (name match /[a-z][a-zA-Z0-9_]*/)
# P_.var
#     same as PolyM("var")
# PolynomialM.new(monomials)
#      monomials be Array of Monomial
# to_s(format)
#       format: "text" then "5x^(4)+3x^(2)+1"  (default)
#               "tex"       "5x^{4}+3x^{2}+1"
#               "texm"      "$5x^{4}+3x^{2}+1$"
#               "prog"      "5*x**(4)+3*x**(2)+1"
# coeff_to_Zp(p)
#     Convert each coefficient to (mod p) for Integer coefficient polynomial.
# coeff_to_Z
#     Rational係数多項式を定数倍して Z係数かつ係数のGCDを1にする.
#       Bug.
#          Float, Complex 係数の動作は保証しない.
# coeff_to_f
#      converts each element to Float
# coeff_truncate
#      truncate each coefficient to Integer
# normalize!
# sort!
#      sort terms in decreasing order. higher term is top.
#
# NOT IMPLEMENTED or IMPERFECT
#  PolynomialM#<=>(other)

require "active_support/core_ext"
require "poly_ruby/number"
require "poly_ruby/poly_work"
require "poly_ruby/polynomial"
require "poly_ruby/polynomialm_parser"
require "poly_ruby/monomial"

# Example.
# a = (P_.x**2 - P_.y**2) / (P_.x - P_.y)
# print a, "\n" # => "x+y"

P_ = Object.new
def P_.method_missing(*a)
  PolynomialM(a[0].id2name)
end


def PolynomialM(poly_arg1 = 0, *poly_arg2)
  case poly_arg1
  when PolynomialM
    return poly_arg1
  when Numeric
    if poly_arg2[0].kind_of?(Hash)
      # coefficient and power product like Monomial
      return PolynomialM.new([Monomial(poly_arg1, poly_arg2[0])])
    else
      return PolynomialM.new([Monomial.new(poly_arg1, {})])
    end
  when String
    # generate var-names as variables in Ruby
    # and eval the expression
    poly_str = PolyWork.cnv_prog_format(poly_arg1)
    poly_m = PolynomialMParser.new(poly_str).parse
    poly_m.normalize!
    return poly_m
  when Polynomial
    return PolynomialM(poly_arg1.to_s("prog"))
  when Monomial # sequence of Monomial
    return PolynomialM.new([poly_arg1] + poly_arg2)
  when Array
    if poly_arg1[0].kind_of? Monomial
      return PolynomialM.new(poly_arg1) # Array of Monomial
    else # A generating function. May be.
      return PolynomialM(Polynomial(poly_arg1))
    end
  else
    raise TypeError
  end
end

class PolynomialM # Polynomial of Multi Variable
  def initialize(monomials = []) # Polynomial is sequence of Monomials.
    @monomials = monomials
  end

  attr :monomials

  def clone
    ms = []
    @monomials.each { |m| ms.push(m.clone) }
    p = PolynomialM.new(ms)
    return p
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
    s = ""; addS = ""
    @monomials.each { |m|
      if m.coeff > 0
        s = s + addS
      end
      s = s + m.to_s(format); addS = "+"
    }
    if (s == ""); s = "0"; end
    s = ms + s + me # math start and math end
    return s
  end

  def normalize!
    @monomials.each_with_index do |m, i|
      next if m.blank?

      if m.coeff == 0
        @monomials[i] = nil # 係数0の項を除く
      else
        @monomials[i].normalize! # 単項式の正規化
      end
    end
    @monomials.compact!
    self.sort!

    # 同類項をまとめる.
    @monomials = @monomials.group_by{|m| m.power}.map do |power,terms|
      m = terms.inject(:+)
      if m.coeff == 0
        nil # 係数0の項を除く
      else
        m
      end
    end
    @monomials.compact!
    self.sort!
  end

  def normalize(monomials)
    monomials = monomials.map do |m|
      next if m.blank?

      if m.coeff == 0
        nil # 係数0の項を除く
      else
        m.normalize! # 単項式の正規化
        m
      end
    end
    monomials.compact!
    monomials.sort!

    # 同類項をまとめる.
    monomials = monomials.group_by{|m| m.power}.map do |power,terms|
      m = terms.inject(:+)
      m
    end
    monomials.compact!
    return monomials
  end

  def lt # LT(Leading Term)
    if self.zero?
      return Monomial(0)
    else
      return @monomials[0]
    end
  end

  def lc # LC(Leading Coefficient)
    if self.zero?
      return 0
    else
      return @monomials[0].coeff
    end
  end

  # HT(Head Term)
  alias_method :ht, :lt
  # HT(Head Coefficient)
  alias_method :hc, :lc

  def lp # leading power product
    if self.zero?; return Monomial(1) else return @monomials[0].power_product end
  end

  def unit?
    if 0 < self.lp.total_degree; return false; end
    lc = self.lc
    return (lc.abs == 1) || (lc.kind_of?(Rational)) || (lc.kind_of?(Float))
  end

  def coeff(var, deg) # v の多項式を見て多項式を返す.
    p = PolynomialM.new
    @monomials.each { |m|
      if m[var] == deg
        m1 = m.clone
        m1.delete(var)
        p.monomials.push(m1)
      end
    }
    p.normalize!; return p
  end

  def vars # 式に含まれる 変数名一覧
    vs = []
    @monomials.each { |m|
      m.powers.each_key { |v|
        if !vs.include(v); vs.push(v); end
      }
    }
    vorder = Monomial.get_var_order
    vs.sort! { |v1, v2| vorder.index(v1) <=> vorder.index(v2) }
    return vs
  end

  def maxdeg(var) # var の多項式と見ての最高次数
    deg = 0
    @monomials.each { |m| if deg < m.power[var]; deg = m.power[var]; end }
    return deg
  end

  def mindeg(var) # var の多項式と見ての最低次数
    deg = nil
    @monomials.each { |m| if (deg == nil) || (deg < m[var]); deg = m[var]; end }
    if deg == nil; deg = 0; end
    return deg
  end

  def sort!(term_order=:lex) # decreasing order. higher term is top.
    @monomials.sort! { |m1, m2| m2.<=>(m1, term_order) }
  end

  def zero?
    self.normalize!; return @monomials.blank?
  end

  def <=>(other)
    return self.lt <=> other.lt
  end

  def <(other)
    return (self.lt <=> other.lt) < 0
  end

  def ==(other)

    l = normalize(self.monomials)
    r = normalize(other.monomials)
    if l.blank? or r.blank?
      return l==r
    end

    return l.zip(r).all?{|lm,rm| lm==rm}
  end

  def coerce(x)
    case x
    when Numeric; return PolynomialM.new([Monomial.new(x, {})]), self
    when Monomial; return PolynomialM.new([x]), self
    when Polynomial; return PolynomialM(x), self
    else; raise TypeError     end
  end

  def negate!
    @monomials.map! {|m| m.-@ }
    return self
  end

  def negate
    p = PolynomialM.new
    @monomials.each { |m| p.monomials.push(-m) }
    return p
  end

  alias -@ negate

  def +(other)

    if other.kind_of?(PolynomialM)
      # concatiname as Array and simplify it.

      if self.zero? and other.zero? # 0+0
        return self
      elsif self.zero? # 0+x
        return other
      else # x+y
        m = self.clone
        m.monomials.concat(other.monomials)
        m.normalize!
        return m
      end
    elsif other.kind_of?(Monomial) || other.kind_of?(Numeric)
      return self + PolynomialM(other)
    else
      x, y = a.coerce(self)
      return x + y
    end
  end

  def -(other)
    self + (-other)
  end

  def *(other)
    if other.kind_of?(PolynomialM)
      multiplied = self.monomials.map do |sm|
        other.monomials.map do |om|
          mul = sm * om
          mul
        end
      end.inject([]) { |sum, m| sum.concat(m) }

      return PolynomialM(self.normalize(multiplied))
    elsif other.kind_of?(Numeric)
      p = self.clone
      p.monomials.each { |m| m.coeff *= other }
      return p
    elsif other.kind_of?(Monomial)
      return self * PolynomialM(other)
    else
      x, y = a.coerce(self)
      return x * y
    end
  end

  def **(n)
    if n.kind_of?(Integer)
      # calculate ** following to binary notation of "power".
      s = self.clone
      s.normalize!
      dup = s.clone

      if n==1
        return s
      end
      (n-1).times{
        s = s * dup
      }
      return s
    else
      raise TypeError
    end
  end

  def divmod(divisors) # return q[],r
    if divisors.kind_of?(Array) && divisors[0].kind_of?(PolynomialM)
      # Multiple division.
      # "divisors" and quotient "q" are Array of PolynomialM
      h = self.clone; h.normalize!
      # sort as heigher be top
      #divisors.sort!{|f1,f2| f2.lt<=>f1.lt};
      ltD = [];  # leading terms of divisors
      q = [];  # quotients
      divisors.each_with_index { |f, i| ltD[i] = f.lt; q[i] = PolynomialM.new }
      r = PolynomialM.new; pw = PolynomialM.new
      while !h.monomials.empty?
        i = 0
        ltH = h.lt
        while i < ltD.size
          if ltH.divisible?(ltD[i])
            qt = ltH / ltD[i]
            q[i].monomials.push(qt)
            pw.monomials.replace([qt])
            h = h - (pw * divisors[i])
            if h.monomials.empty?; break; end
            ltH = h.lt
            i = 0
          else
            i = i + 1
          end
        end
        if !h.monomials.empty?; r.monomials.push(ltH); h.monomials.shift; end
      end
      return q, r
    elsif divisors.kind_of?(PolynomialM)
      return self.divmod([divisors])
    elsif divisors.kind_of?(Numeric)
      p = self.clone
      p.monomials.each { |m| m.coeff = Number.divII(m.coeff, divisors) }
      return [p], PolynomialM(0)
    elsif divisors.kind_of?(Monomial)
      return self.divmod([PolynomialM(divisors)])
    else
      x, y = divisors.coerce(self)
      return x.divmod(y)
    end
  end

  def /(other) # other be PolynomialM
    q, r = self.divmod(other); return q[0]
  end

  def %(other) # other be PolynomialM
    q, r = self.divmod(other); return r
  end

  def divmodZp(divisors, p) # return q[],r
    if divisors.kind_of?(Array) && divisors[0].kind_of?(PolynomialM)
      # Multiple division.
      # "divisors" and quotient "q" are Array of PolynomialM
      h = self.coeff_to_Zp(p)
      #divisors.sort!{|f1,f2| f2.lt<=>f1.lt};
      ltD = [];  # leading terms of divisors
      q = [];  # quotients
      divisors.each_with_index { |f, i| ltD[i] = f.lt; q[i] = PolynomialM.new }
      r = PolynomialM.new; pw = PolynomialM.new
      while !h.monomials.empty?
        ltH = h.lt
        i = 0
        while i < ltD.size
          if ltH.divisible?(ltD[i])
            qt = ltH.div_zp(ltD[i], p)
            q[i].monomials.push(qt)
            pw.monomials.replace([qt])
            h = h - (pw * divisors[i])
            h = h.coeff_to_Zp(p)
            if h.monomials.empty?; break; end
            ltH = h.lt
            i = 0
          else
            i = i + 1
          end
        end
        if !h.monomials.empty?; r.monomials.push(ltH); h.monomials.shift; end
      end
      r = r.coeff_to_Zp(p)
      return q, r
    else
      return self.divmodZp([PolynomialM(divisors)])
    end
  end

  def divmod_i(divisors) # return q[],r
    if divisors.kind_of?(Array) && divisors[0].kind_of?(PolynomialM)
      # Multiple division.
      # "divisors" and quotient "q" are Array of PolynomialM
      h = self.clone; h.normalize!
      #divisors.sort!{|f1,f2| f2.lt<=>f1.lt};
      ltD = [];  # leading terms of divisors
      q = [];  # quotients
      divisors.each_with_index { |f, i| ltD[i] = f.lt; q[i] = PolynomialM.new }
      r = PolynomialM.new; pw = PolynomialM.new
      while !h.monomials.empty?
        ltH = h.lt
        i = 0
        while i < ltD.size
          if ltH.divisibleI?(ltD[i])
            qt, rt = ltH.divmod_i(ltD[i])
            q[i].monomials.push(qt)
            pw.monomials.replace([qt])
            h = h - (pw * divisors[i])
            if h.monomials.empty?; break; end
            ltH = h.lt
            i = 0
          else
            i = i + 1
          end
        end
        if !h.monomials.empty?; r.monomials.push(ltH); h.monomials.shift; end
      end
      return q, r
    elsif divisors.kind_of?(Numeric)
      return self.divmod_i([PolynomialM(divisors)])
    else
      return self.divmod_i([PolynomialM(divisors)])
    end
  end

  def substitute(list) # list is Hash of "var"=>val
    f = PolynomialM.new
    self.monomials.each { |m|
      fw = PolynomialM(m.coeff)
      m.power.each_pair { |var, deg|
        if list.has_key?(var); fw1 = list[var] ** deg else fw1 = PolynomialM.new([Monomial.new(1, { var => deg })]) end
        fw = fw * fw1
      }
      f = f + fw
    }
    return f
  end

  def derivative(vars) # vars is Array of var names
    f = self.clone
    for m in f.monomials
      for var in vars
        if m.power.has_key?(var)
          p = m.power[var]
          m.coeff = m.coeff * p
          if p == 1
            m.power.delete(var)
          else
            m.power[var] = p - 1
          end
        else
          m.coeff = 0
          break
        end
      end
    end
    f.normalize!
    return f
  end

  def integral(vars) # vars is Array of var names
    f = self.clone
    for m in f.monomials
      for var in vars
        if m.power.has_key?(var)
          p = m.power[var] + 1
          m.power[var] = p
          m.coeff = Number.divII(m.coeff, p)
        else m.power[var] = 1         end
      end
    end
    f.normalize!
    return f
  end

  def lcm_coeff_denom # lcm of of denominator of coefficients as Rarional
    den = [1]
    @monomials.each { |m|
      c = m.coeff
      if c.kind_of?(Rational); den.push(c.denominator.abs); end
    }
    return Number.lcm(den)
  end

  def gcd_coeff_num # gcd of numerator of coefficients as Rational
    num = [1]
    @monomials.each { |m|
      c = m.coeff
      if c.kind_of?(Rational) || c.kind_of?(Integer); num.push(c.numerator.abs); end
    }
    return Number.gcd(num)
  end

  def coeff_truncate # truncate each coefficient to Integer
    f = self.clone
    for i in 0..f.monomials.size - 1
      f.monomials[i].coeff = f.monomials[i].coeff.to_i
    end
    f.normalize!
    return f
  end

  def coeff_to_f # converts each element to Float
    f = self.clone
    for i in 0..f.monomials.size - 1
      f.monomials[i].coeff = f.monomials[i].coeff.to_f
    end
    f.normalize!
    return f
  end

  def coeff_to_Z # Rational係数多項式を定数倍して Z係数かつ係数のGCDを1にする.
    f = self * self.lcm_coeff_denom
    f = f / f.gcd_coeff_num
    f = f.coeff_truncate
    return f
  end

  def coeff_to_Zp(p)
    f = self.clone
    for i in 0..f.monomials.size - 1
      f.monomials[i].coeff = Number.modP(f.monomials[i].coeff, p)
    end
    f.normalize!
    return f
  end

  def inspect
    if @monomials.blank?
      return "PolynomialM()"
    else
      return sprintf "PolynomialM([%s])", @monomials.join(",")
    end
  end

end #PolynomialM

# alias
PolyM = PolynomialM
