require "poly_ruby/polynomial"
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
end
