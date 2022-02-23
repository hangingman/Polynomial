# coding: utf-8
require "poly_ruby/rationalpoly"


RSpec.describe RationalPoly do

  context "Given some rational polynomials" do
    r1=RationalPoly("x^2+1","x+2")
    r2=RationalPoly("x+2","x+1")

    it "can do several arithmetic operations" do
      expect((r1+r2).to_s).to eq "(x^(3)+2x^(2)+5x+5)/(x^(2)+3x+2)"
      expect((r1-r2).to_s).to eq "(x^(3)-3x-3)/(x^(2)+3x+2)"
      expect((r1*r2).to_s).to eq "(x^(3)+2x^(2)+x+2)/(x^(2)+3x+2)"
    end
    it "can do reduction (need to write reduction explicitly.)" do
      expect((r1*r2).reduce.to_s).to eq "(x^(2)+1)/(x+1)"
      expect((r1/r2).to_s).to eq "(x^(3)+x^(2)+x+1)/(x^(2)+4x+4)"
    end
    it "can do factorial" do
      expect((r2**(2)).to_s).to eq "(x^(2)+4x+4)/(x^(2)+2x+1)"
    end
    it "can do divide operation, return modulo" do
      q,r=r1.divmod(r2)
      expect(q.to_s).to eq "x-3"
      expect(r.to_s).to eq "(9x+13)/(x^(2)+3x+2)"
    end
    it "can do derivative" do
      expect(r1.derivative.to_s).to eq "(x^(2)+4x-1)/(x^(2)+4x+4)"
      expect(r1.derivative(2).to_s).to eq "(10)/(x^(3)+6x^(2)+12x+8)"
      expect(r1.derivative(3).to_s).to eq "(-30)/(x^(4)+8x^(3)+24x^(2)+32x+16)"
    end
  end
end
