require "poly_ruby/polynomialm_parser"
require "poly_ruby/polynomialm"


#RSpec.describe PolynomialMParser do
RSpec.describe PolynomialMParser do

  describe "#parse" do
    parser = PolynomialMParser

    it "3 == PolynomialM('3')" do
      expect(parser.new("3").parse).to eq PolynomialM("3")
    end
    it "3^2 == PolynomialM('9')" do
      expect(parser.new("3^2").parse).to eq PolynomialM("9")
    end
    it "3**2 == PolynomialM('9')" do
      expect(parser.new("3**2").parse).to eq PolynomialM("9")
    end
    it "3*a == PolynomialM('3a')" do
      expect(parser.new("3*a").parse).to eq PolynomialM("3a")
    end
    it "3a^2 == PolynomialM('9a^2')" do
      expect(parser.new("3*a^2").parse).to eq PolynomialM("3a^2")
    end
    it "3*a**2 == PolynomialM('9a^2')" do
      expect(parser.new("3*a**2").parse).to eq PolynomialM("3a^2")
    end
    it "3*x^2/2 == PolynomialM('3x^2/2')" do
      expect(parser.new("3*x^2/2").parse).to eq PolynomialM("3x^2/2")
    end
    it "(2x-7) == PolynomialM('2x-7')" do
      expect(parser.new("2*x-7").parse).to eq PolynomialM("2x-7")
    end
    it "-(2x-7) == PolynomialM('-2x+7')" do
      expect(parser.new("-(2*x-7)").parse).to eq PolynomialM("-2x+7")
      expect(parser.new("-(-(2*x-7))").parse).to eq PolynomialM("2x-7")
    end
    it "(x+2)(x+3) == x^2+5x+6" do
      expect(parser.new("(x+2)*(x+3)").parse).to eq PolynomialM("(x+2)(x+3)")
      expect(parser.new("(x+2)*(x+3)").parse).to eq PolynomialM("x^2+5x+6")
    end
    xit "(2x-3)^3 == 8x^3-36x^2+54x-27" do
      poly_str = PolyWork.cnv_prog_format("(2x-3)^3")
      expect(parser.new(poly_str).parse.to_s).to eq PolynomialM("8x^3-36x^2+54x-27").to_s
    end
    xit "2(2x-3)^3 == 16x^3-72x^2+108x-54" do
      poly_str = PolyWork.cnv_prog_format("2(2x-3)^3")
      expect(parser.new(poly_str)).to eq PolynomialM("16x^3-72x^2+108x-54")
    end

  end
end
