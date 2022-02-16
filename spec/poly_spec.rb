# coding: utf-8
require "poly_ruby/polynomial"
require "poly_ruby/gbasei1"


RSpec.describe Polynomial do

  it "can convert string to polynomial" do
    expect(Polynomial("3x^2/2+5/2*x+7/2").to_s).to eq "3x^(2)/2+5x/2+7/2"
    expect(Polynomial("(x^2-2x+4)^2").to_s).to eq "x^(4)-4x^(3)+12x^(2)-16x+16"
  end

  it "can convert integer to polynomial" do
    expect(Polynomial(2).to_s).to eq "2"
  end

  it "can convert array to polynomial" do
    expect(Polynomial([3,2,1]).to_s).to eq "x^(2)+2x+3"
    expect(Polynomial([6,5,4]).to_s).to eq "4x^(2)+5x+6"
  end

  it "can convert term to polynomial" do
    expect(Polynomial.term(3,2).to_s).to eq "3x^(2)"
  end

  context "Given some polynomials" do
    f1=Polynomial("(x^2-2x+4)^2")
    f2=Polynomial(2)
    f3=Polynomial([3,2,1])
    f4=Polynomial([6,5,4])
    f5=Polynomial.term(3,2)

    describe "#divmod" do
      it "can calc div and modulo" do
        f6=f1+f2*f3+5*f4+f5**2
        expect(f6.to_s).to eq "10x^(4)-4x^(3)+34x^(2)+13x+52"
        q,r=f1.divmod(f4)
        expect(q.to_s).to eq "x^(2)/4-21x/16+273/64"
        expect(r.to_s).to eq "-1885x/64-307/32"
      end
    end

    describe "#substitute" do
      it "can substitule a number" do
        f7=f1.substitute(2);
        expect(f7.to_s).to eq "16"
      end
      it "can substitute a polynomial to a polynomial" do
        f8=f1.substitute(f3);
        expect(f8.to_s).to eq "x^(8)+8x^(7)+32x^(6)+80x^(5)+142x^(4)+184x^(3)+176x^(2)+112x+49"
      end
    end
  end
  describe "#factor2s" do
    it "can calc factorization in Integer coefficient" do
      f=Polynomial("(x^3-1)(x^3+1)")
      expect(f.to_s).to eq "x^(6)-1"
      expect(Polynomial.factor2s(f.factorize)).to eq "(x-1)(x+1)(x^(2)-x+1)(x^(2)+x+1)"
    end
    it "can calc factorization in Rational coefficient" do
      f=Polynomial("(x^3-1/27)(x^3+1/8)")
      expect(f.to_s).to eq "x^(6)+19x^(3)/216-1/216"
      expect(Polynomial.factor2s(f.factorize)).to eq "(2x+1)(3x-1)(4x^(2)-2x+1)(9x^(2)+3x+1)"
    end
  end
  describe "#countSolution" do
    parameterized do
      where(:s, :answer, size: 3) do
        [
          ["(x^2+1)^2(x-1)", 1],
          ["(x-1)(x-2)(x-3)", 3],
          ["(x^2+1)^2(x-1)^2", 2]
        ]
      end
      with_them do
        it "can count solutions of f(x)=0" do
          f=Polynomial(s)
          expect(f.countSolution).to eq answer
        end
      end
    end
  end
  describe "#countSolution (We can control support range and duplications. By default, range is real number and count duplication.)" do
    s = "(x-1)^3(x+2)^2"
    f=Poly(s)
    it "can count all solutions" do
      expect(f.countSolution).to eq 5
    end
    it "can count posotive solutions" do
      expect(f.countSolution(0,Infinity)).to eq 3
    end
    it "can count solutions with eliminating duplication" do
      expect(f.countSolution(-Infinity,Infinity,false)).to eq 2
    end
    it "can count positive solutions with eliminating duplication" do
      expect(f.countSolution(0,Infinity,false)).to eq 1
    end
  end
  describe "Grobner basis in Z[x]" do
    f1=Polynomial("2x^(4)-2x^(2)+8x+10")
    f2=Polynomial("3x^(4)+12x+15")
    f3=Polynomial("2x^(5)+12x^(4)-2x^(3)+10x^(2)+58x+62")
    flist=[f1,f2,f3]
    flist2=GBaseI1.getGBaseI1(flist)
    it "can retrieve Groebner basis" do
      expect(flist2[0].to_s).to eq "x^(4)+1"
      expect(flist2[1].to_s).to eq "2"
    end
  end
end
