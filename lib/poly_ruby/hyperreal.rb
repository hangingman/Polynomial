# class HyperReal
# Non-standard extension of Real(Integer,Rational,Float) number.
#
#######################################
# K.Kodama(kodama@kobe-kosen.ac.jp) 2000-04-23
#
# This module is distributed freely in the sence of
# GPL(GNU General Public License).
#######################################
# FUNCTION
#     HyperReal(r)
#         Generate HyperReal number as "r".
# ARITHMETIC:
#     -, +, *, /, abs
#     **(n) # Restriction: n be Integer.
# CONVERTING:
#     reduce, reduce!
#     to_f
#     to_poly(deg=false)
#     to_std # return standard part
#     to_s(standard=true)# true: Rational, false: rational form of HyperReal
#     approx(deg=false)
#        Taylor approximation of degree "deg"
#        convert from rational form to polynomial form.
#        if max_deg is Integer then use numerator.degree + denominator.degree*2
#     to_approx_poly(deg=false)
#        Polynmial of Taylor approximation of degree "deg"
#     HyperReal.Inf_to_HyperInf(f)
#        if f is Float::Inf(-Inf, NaN resp.),
#        then return HyperReal::Infinity(-Infinity, Indefinite resp.)
#        else return f itself.
#
# TESTING:
#     <=>
#     sim_eql?(other) # Have same standard part?
#     finite?  # Isfinite number?
#     indefinite? # Is indefinite?
#     infinite? # Is +-infinite number?
#     positive_infinite? # Is positive infinite number?
#     negative_infinite? # Is negative infinite number?
# CONSTANT:
#     HyperReal::Epsilon
#     HyperReal::Infinity
#     HyperReal::Indefinite
# OTHER
#     clone
#     F_to_IR[0]
#        If true then convert Float to Rational in function HperReal()

def HyperReal(r)
  if r.kind_of?(HyperReal)
    r.clone
  elsif r.kind_of?(RationalPoly)
    HyperReal.new(r)
  elsif r.kind_of?(Integer)
    HyperReal.new(RationalPoly(r))
  elsif r.kind_of?(Rational)
    HyperReal.new(RationalPoly(r))
  elsif r.kind_of?(Float)
    if HyperReal::F_to_IR[0]
      ir = RationalPoly(r.to_ir)
    else
      ir = HyperReal.Inf_to_HyperInf(r)
    end
    if ir.kind_of?(HyperReal)
      ir
    else
      HyperReal.new(RationalPoly(ir))
    end
  else
    raise TyoeError
  end
end

class HyperReal < Numeric
  require "poly_ruby/rationalpoly"

  F_to_IR = [true]

  def initialize(r = RationalPoly("x", 1))
    if r.kind_of?(RationalPoly); @val = r.clone else raise TypeError end
  end

  attr :val

  def clone
    HyperReal.new(@val.clone)
  end

  r = RationalPoly("x", 1)
  Epsilon = HyperReal.new(r)
  Infinity = HyperReal.new(1 / r)
  Indefinite = HyperReal.new
  Indefinite.val.numerator = Poly("0")
  Indefinite.val.denominator = Poly("0")

  def HyperReal.Inf_to_HyperInf(f)
    # If f is Float::Inf(-Inf, NaN resp.),
    # then return HyperReal::Infinity(-Infinity, Indefinite resp.)
    # else return f itself.
    if f.kind_of?(Float) && f.to_s == "Infinity"
      Infinity
    elsif f.kind_of?(Float) && f.to_s == "-Infinity"
      -Infinity
    elsif f.kind_of?(Float) && f.to_s == "NaN"
      Indefinite
    else
      f
    end
  end

  def reduce
    HyperReal(self.val.reduce)
  end

  def reduce!
    HyperReal(self.val.reduce!)
  end

  def finite?
    v = @val.reduce
    num = v.numeretor
    den = v.denominator
    (den[0] != 0) || ((den != 0) && (num == 0))
  end

  def indefinite?
    (v.denominator == 0)
  end

  def infinite? # +-infinite number
    v = @val.reduce
    num = v.numeretor
    den = v.denominator
    (den[0] == 0) && ((den != 0) && (num[0] != 0))
  end

  def positive_infinite?
    v = @val.reduce
    num = v.numeretor
    den = v.denominator
    (den[0] == 0) && (0 < (num[0] * den[den.mindeg]))
  end

  def negative_infinite?
    v = @val.reduce
    num = v.numeretor
    den = v.denominator
    (den[0] == 0) && (0 > (num[0] * den[den.mindeg]))
  end

  def to_std # return standard part
    v = @val.reduce
    num = v.numerator
    den = v.denominator
    if den[0] != 0; Number.divII(num[0], den[0]) elsif den != 0
                                                   if num == 0; 0 else
                                                                    if 0 < (num[0] * den[den.mindeg])
                                                                      Number.Inf_IEEE754
 else -Number.Inf_IEEE754; end
                                                   end
    else
      Number.NaN_IEEE754
    end
  end

  def to_s(standard = true) # true: Rational, false: rational form of HyperReal
    v = @val.reduce
    num = v.numerator
    den = v.denominator
    if standard
      if den[0] != 0; Number.divII(num[0], den[0]).to_s elsif den != 0
                                                          if num == 0; "0" else
                                                                             if 0 < (num[0] * den[den.mindeg])
                                                                               "Infinity" else "-Infinity"
 end
                                                          end
      else
        "Indefinite"
      end
    else
      "(" + num.to_s("text", "e", false) + ")/(" + den.to_s("text", "e", false) + ")"
    end
  end

  def to_f
    self.to_std.to_f
  end

  def approx(deg = false)
    # Taylor approximation of degree "deg"
    HyperReal(@val.approx(deg))
  end

  def to_approx_poly(deg = false)
    # Polynmial of Taylor approximation of degree "deg"
    self.approx(deg).val.numerator
  end

  def to_RationalPoly
    @val
  end

  def <=>(other) # compare as non-standard number
    r = (self - other).val.reduce
    num = r.numerator
    den = r.denominator
    if den == 0; 0.0 / 0.0 # return NaN
      elsif num == 0; 0 else
                          (den[den.mindeg] * num[num.mindeg]) <=> 0
    end
  end

  def ==(other) # Same as non-standard number?
    0 == (self <=> other)
    # r=(self<=>other); return (r.kind_of?(Integer)&&(0==r))
  end

  def sim_eql?(other) # Have same standard part?
    s = self - other
    s.finite? && (s.to_std == 0)
  end

  def -@
    HyperReal.new(-@val)
  end

  def abs
    if self < 0; -self; else self; end
  end

  def +(x)
    if x.kind_of?(HyperReal)
      HyperReal.new(@val + x.val)
    elsif x.kind_of?(Integer) || (defined?(Rational) && x.kind_of?(Rational))
      HyperReal.new(@val + x)
    elsif x.kind_of?(Float)
      self + HyperReal(x)
    else a, b = x.coerce(self)
         a + b     end
  end

  def -(x)
    if x.kind_of?(HyperReal)
      HyperReal.new(@val - x.val)
    elsif x.kind_of?(Integer) || (defined?(Rational) && x.kind_of?(Rational))
      HyperReal.new(@val - x)
    elsif x.kind_of?(Float)
      self - HyperReal(x)
    else a, b = x.coerce(self)
         a - b     end
  end

  def *(x)
    if x.kind_of?(HyperReal)
      HyperReal.new(@val * x.val)
    elsif x.kind_of?(Integer) || (defined?(Rational) && x.kind_of?(Rational))
      HyperReal.new(@val * x)
    elsif x.kind_of?(Float)
      self * HyperReal(x)
    else a, b = x.coerce(self)
         a * b     end
  end

  def /(x)
    if x.kind_of?(HyperReal)
      num = @val.numerator * x.val.denominator
      den = @val.denominator * x.val.numerator
      HyperReal.new(RationalPoly.new(num, den))
    elsif x.kind_of?(Integer) || (defined?(Rational) && x.kind_of?(Rational))
      self / HyperReal.new(RationalPoly(x))
    elsif x.kind_of?(Float)
      self / HyperReal(x)
    else a, b = x.coerce(self)
         a / b     end
  end

  def **(n) # Restriction: n be Integer.
    if n.kind_of?(Integer); HyperReal.new(@val ** n) else raise TypeError end
  end

  def coerce(other)
    case other
    when Integer; [HyperReal(other), self]
    when Rational; [HyperReal(other), self]
    when Float; [HyperReal(other), self]
    else raise TypeError
    end
  end
end # HyperReal
