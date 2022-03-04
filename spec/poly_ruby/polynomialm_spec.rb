# coding: utf-8
require "poly_ruby/polynomialm" # multi variable polynomial class
require "poly_ruby/gbasem" # Rational, Complex or Z/pZ coefficients Grobner basis
require "poly_ruby/gbasei" # Z coefficient Grobner basis


RSpec.describe PolynomialM do

  it "can convert string to m-polynomial" do
    expect(PolynomialM("3x^2/2+5/2*x+7/2").to_s).to eq "3x^(2)/2+5x/2+7/2"
    expect(PolynomialM("x^2+3x*y+y^3").to_s).to eq "y^(3)+x^(2)+3x*y"
    expect(PolynomialM("(y-1)^3").to_s).to eq "y^(3)-3y^(2)+3y-1"
    expect(PolynomialM("x+y^2").to_s).to eq "y^(2)+x"
  end

  it "can do arithmetic operations for m-polynomial" do
    f1=PolynomialM("x^2+3x*y+y^3")
    f2=PolynomialM("(y-1)^3")
    f3=PolynomialM("x+y^2")
    f4=f1+f2-2*f3*f1+f3**2
    expect(f4.to_s).to eq "-2y^(5)-2x^(2)*y^(2)-8x*y^(3)+y^(4)-2x^(3)-6x^(2)*y+2x*y^(2)+2y^(3)+2x^(2)+3x*y-3y^(2)+3y-1"
  end

  describe "#divmod" do
    f1=PolynomialM("x^2+3x*y+y^3")
    f2=PolynomialM("(y-1)^3")
    f3=PolynomialM("x+y^2")
    f4=f1+f2-2*f3*f1+f3**2
    it "can calc div and modulo" do
      # divmod supprots multi division.
      # It returns a pair [quotients,residue].
      # In the following sample, We get multi division f4 by f2,f3.
      q,r=f4.divmod([f1,f2])
      expect(q[0].to_s).to eq "-2y^(2)-2x+y+2"
      expect(q[1].to_s).to eq "0"
      expect(r.to_s).to eq "-x^(2)*y-x*y^(2)-3x*y-3y^(2)+3y-1"
    end
  end

  describe "#substitute" do
    it "f(x,y) = x+y^(2); f(2,1) = 3" do
      f3=PolynomialM("x+y^2")
      f5=f3.substitute("x"=>2,"y"=> 1)
      expect(f5.to_s).to eq "3"
    end
    # We can use substitute method to polynomials.
    # In the following sample, We exchange x and y each other.
    it "f(x,y) = x+y^(2); f(y,x) = x^2+y" do
      f3=PolynomialM("x+y^2")
      f5=f3.substitute("x"=>PolynomialM("y"),"y"=>PolynomialM("x"))
      expect(f5.to_s).to eq "x^(2)+y"
    end
  end

  describe "#derivative" do
    it "f(x) = (x+2)(x+3); d/dx f(x) = 2x+5" do
      f1=PolynomialM("(x+2)(x+3)")
      f2=f1.derivative(["x"])
      expect(f2.to_s).to eq "2x+5"
    end
    it "f(x) = (2x-3)^4; d/dx f(x) = 8(2x-3)^3" do
      f1=PolynomialM("(2x-3)^4")
      f2=f1.derivative(["x"])
      expect(f1.to_s).to eq "16x^(4)-96x^(3)+216x^(2)-216x+81"
      expect(f2.to_s).to eq "64x^(3)-288x^(2)+432x-216"
    end
    it "f(y) = (y-1)^3; d^3f/dx^2/dy f(y) = 0" do
      f2=PolynomialM("(y-1)^3")
      f6=f2.derivative(["x","x","y"])
      expect(f6.to_s).to eq "0"
    end
  end
  describe "#integral" do
    it "f(x,y) = x+y^2; ∫ f(x,y) dx dy = x*y^(3)/3+x^(2)*y/2" do
      f3=PolynomialM("x+y^2")
      f7=f3.integral(["x","y"])
      expect(f7.to_s).to eq "x*y^(3)/3+x^(2)*y/2"
    end
  end
end


RSpec.describe GBase do

  describe "#getGBase; sample1: solve equation using Grobner basis" do
    context "f1=x+y+2z-2, f2=2x+3y+6z-5, f3=3x+2y+4z-5" do
      f1=PolynomialM("x+y+2z-2")
      f2=PolynomialM("2x+3y+6z-5")
      f3=PolynomialM("3x+2y+4z-5")

      it do
        gbasis=GBase.getGBase([f1,f2,f3])
        expect(gbasis.map(&:to_s)).to match ["x-1/1", "y+2z-1"]
      end
    end
  end

  describe "#getGBase; sample2: Grobner basis" do

    context "f1=3x^2y-y*z, f2=x*y^2+z^4" do
      f1=PolynomialM("3x^2y-y*z")
      f2=PolynomialM("x*y^2+z^4")

      context "with lex term order" do
        it do
          Monomial.set_term_order("lex")
          gbasis=GBase.getGBase([f1,f2])
          expect(gbasis.map(&:to_s)).to match ["x^(2)*y-y*z/3", "x*y^(2)+z^(4)", "x*z^(4)+y^(2)*z/3", "y^(4)*z-3z^(8)"]
        end
      end
      context "with deglex term order" do
        it do
          Monomial.set_term_order("deglex")
          gbasis=GBase.getGBase([f1,f2])
          expect(gbasis.map(&:to_s)).to match ["z^(4)+x*y^(2)", "x^(2)*y-y*z/3"]
        end
      end
    end
  end

  describe "#getGBaseZp; sample3: Grobner basis in Z/5Z coefficients" do
    context "f1=x+y+2z-2, f2=2x+3y+6z-5, f3=3x+2y+4z-5" do
      f1=PolynomialM("x^2+y^2+1")
      f2=PolynomialM("x^2y+2x*y+x")

      it do
        gbasis=GBase.getGBaseZp([f1,f2],5)
        expect(gbasis.map(&:to_s)).to match ["y^(3)+3x*y+4x+y", "x^(2)+y^(2)+1"]
      end
    end
  end

  describe "#getGBaseI; sample4: Grobner basis in Z coefficnents" do
    context "f1=6x^2+y^2, f2=10x^2y+2x*y" do
      Monomial.set_var_order
      Monomial.set_term_order("lex")
      f1=PolynomialM("6x^2+y^2")
      f2=PolynomialM("10x^2y+2x*y")

      it do
        gbasis=GBaseI.getGBaseI([f1,f2])
        expect(gbasis.map(&:to_s)).to match ["x^(2)*y^(3)+y^(5)+4x*y^(3)+y^(3)",
                                             "2x^(2)*y+2y^(3)-2x*y",
                                             "5y^(3)-6x*y",
                                             "6x^(2)+y^(2)"]
      end
    end
  end
end
