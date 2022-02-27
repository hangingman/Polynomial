require "poly_ruby/polynomialm" # multi variable polynomial class
require "poly_ruby/gbasem" # Rational, Complex or Z/pZ coefficients Grobner basis
require "poly_ruby/gbasei" # Z coefficient Grobner basis


RSpec.describe PolynomialM do

  it "can convert string to m-polynomial" do
    expect(PolynomialM("3x^2/2+5/2*x+7/2").to_s).to eq "3x^(2)/2+5x/2+7/2"
    expect(PolynomialM("x^2+3x*y+y^3").to_s).to eq "x^(2)+3x*y+y^(3)"
    expect(PolynomialM("(y-1)^3").to_s).to eq "y^(3)-3y^(2)+3y-1"
    expect(PolynomialM("x+y^2").to_s).to eq "x+y^(2)"
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
      #expect(f2.to_s).to eq ""
      #expect(f2.to_s).to eq PolynomialM("8*(2*x-3)**3").to_s
    end
    it "" do
      #print "-- derivative\n"
      #f2=PolynomialM("(y-1)^3")
      #f6=f2.derivative(["x","x","y"])
      #printf 'f2.derivative(["x","x","y"])=%s'+"\n",f6
    end
  end
  it "" do
    #
    # print "-- integral\n"
    # f7=f3.integral(["x","y"])
    # printf 'f3.integral(["x","y"])=%s'+"\n",f7
  end

  skip "" do
    f = PolynomialM("x+y^2").substitute("x" => PolynomialM("y"), "y" => PolynomialM("x"))
    print f, "\n"
  end
end


RSpec.describe GBase do
  skip "skip" do
    print "---- sample 1 ---\n"
    print "-- solve equation using Grobner basis\n"
    f1=PolynomialM("x+y+2z-2")
    f2=PolynomialM("2x+3y+6z-5")
    f3=PolynomialM("3x+2y+4z-5")
    printf "%s =0, %s =0, %s =0\n",f1,f2,f3
    gbasis=GBase.getGBase([f1,f2,f3])
    printf "Groebner baseis: %s\n", gbasis.join(", ")
    str="";d=""; gbasis.each{|f| str=str+d+f.to_s+" =0"; d=", "}
    printf "Solution: %s\n", str

    print "---- sample 2 ---\n"
    print "-- Grobner basis in degrevlex order \n"
    f1=PolynomialM("3x^2y-y*z")
    f2=PolynomialM("x*y^2+z^4")
    printf "%s, %s\n",f1,f2
    gbasis=GBase.getGBase([f1,f2])
    printf "Groebner base: %s\n", gbasis.join(", ")

    print "-- with deglex term order\n"
    # Monomial.set_term_order(t)
    #	 t= "lex"(default), "deglex",  "degrevlex"
    Monomial.set_term_order("deglex")
    gbasis=GBase.getGBase([f1,f2])
    printf "Groebner basis: %s\n", gbasis.join(", ")
    Monomial.set_term_order

    print "---- sample 3 ---\n"
    print "-- Grobnae basis in Z/5Z coefficients. \n"
    f1=PolynomialM("x^2+y^2+1")
    f2=PolynomialM("x^2y+2x*y+x")
    printf "%s, %s\n",f1,f2
    gbasis=GBase.getGBaseZp([f1,f2],5)
    printf "Groebner basis: %s\n", gbasis.join(", ")

    print "--- sample 4 ---\n"
    print "-- Grobner basis in Z coefficnents. \n"
    Monomial.set_var_order
    Monomial.set_term_order("lex")
    f1=PolynomialM("6x^2+y^2")
    f2=PolynomialM("10x^2y+2x*y")
    printf "%s, %s\n",f1,f2
    gbasis=GBaseI.getGBaseI([f1,f2])
    printf "Groebner basis: %s\n", gbasis.join(", ")
  end
end
