require "poly_ruby/polynomialm_parser"
require "poly_ruby/polynomialm"


RSpec.describe PolynomialMParser do

  skip "#parse" do
    parser = PolynomialMParser

    it "3 == PolynomialM('3')" do
      expect(parser.parse("3")).to eq PolynomialM("3")
    end
    it "3^2 == PolynomialM('9')" do
      expect(parser.parse("3^2")).to eq PolynomialM("9")
    end
    it "3**2 == PolynomialM('9')" do
      expect(parser.parse("3**2")).to eq PolynomialM("9")
    end
    it "3*a == PolynomialM('3a')" do
      expect(parser.parse("3*a")).to eq PolynomialM("3a")
    end
    it "3a^2 == PolynomialM('9a^2')" do
      expect(parser.parse("3*a^2")).to eq PolynomialM("3a^2")
    end
    it "3*a**2 == PolynomialM('9a^2')" do
      expect(parser.parse("3*a**2")).to eq PolynomialM("3a^2")
    end
    it "3*x^2/2 == PolynomialM('3x^2/2')" do
      expect(parser.parse("3*x^2/2")).to eq PolynomialM("3x^2/2")
    end
    it "(2x-7) == PolynomialM('2x-7')" do
      expect(parser.parse("2*x-7")).to eq PolynomialM("2x-7")
    end
    it "-(2x-7) == PolynomialM('-2x+7')" do
      expect(parser.parse("-(2*x-7)")).to eq PolynomialM("-2x+7")
      expect(parser.parse("-(-(2*x-7))")).to eq PolynomialM("2x-7")
    end
    it "(x+2)(x+3) == x^2+5x+6" do
      expect(parser.parse("(x+2)*(x+3)")).to eq PolynomialM("(x+2)(x+3)")
      expect(parser.parse("(x+2)*(x+3)")).to eq PolynomialM("x^2+5x+6")
    end
    it "(2x-3)^3 == 8x^3-36x^2+54x-27" do
      poly_str = PolyWork.cnv_prog_format("(2x-3)^3")
      expect(parser.parse(poly_str)).to eq PolynomialM("8x^3-36x^2+54x-27")
    end
    xit "2(2x-3)^3 == 16x^3-72x^2+108x-54" do
      poly_str = PolyWork.cnv_prog_format("2(2x-3)^3")
      expect(parser.parse(poly_str)).to eq PolynomialM("16x^3-72x^2+108x-54")
    end

  end
end
