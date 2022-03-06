require "poly_ruby/polynomial"
require "poly_ruby/polynomialm"
require "poly_ruby/poly_work"
require "poly_ruby/elapse"

RSpec.describe PolyRuby do
  it "has a version number" do
    expect(PolyRuby::VERSION).not_to be nil
  end

  it "does something useful" do
    n = 32*2**2
    p1 = Poly("x+1")**n
    p2 = Poly("x+2")**n
    f1 = p1.timesSep(p2, p1.degree, p2.degree)
    f2 = p1.timesCnv(p2)
    expect(n).to eq 128
    expect(f1==f2).to be true
  end

  context "f(x) = x^5-2y*x^2+y^5, g(x) = x^2-x^2-1" do

    f=PolynomialM(PolyWork.cnv_prog_format("x^5-2y*x^2+y^5"))
    g=PolynomialM(PolyWork.cnv_prog_format("x^2-y^2-1"))
    f.sort!(:lex)
    g.sort!(:lex)

    it "HT(f) = x^5, HC(f) = 1" do
      expect(f.ht.to_s).to eq "x^(5)"
      expect(f.hc.to_s).to eq "1"
    end
    it "HT(g) = x^2, HC(g) = 1" do
      expect(g.ht.to_s).to eq "x^(2)"
      expect(g.hc.to_s).to eq "1"
    end
    it "spoly(f,g) = " do
      ht_f=f.ht
      ht_g=g.ht
      hm_f=f.ht
      hm_g=g.ht

      #p (ht_f.lcm(ht_g)/hm_f)*f - (ht_f.lcm(ht_g)/hm_g)*g
    end
  end

end
