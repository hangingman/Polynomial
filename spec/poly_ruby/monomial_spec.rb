require "poly_ruby/monomial"


RSpec.describe Monomial do

  it "can convert string to monomial" do
    expect(Monomial(c=3, p={"x"=>2}).to_s).to eq "3x^(2)"
    expect(Monomial(c=5, p={"x"=>1}).to_s).to eq "5x"
    expect(Monomial(c=3, p={"x"=>1, "y"=>1}).to_s).to eq "3x*y"
  end
  it "can convert integer to monomial" do
    expect(Monomial(c=2, p={"x"=>0}).to_s).to eq "2"
  end
  it "can get/set term order" do
    Monomial.set_term_order("lex")
    expect(Monomial.get_term_order).to eq "lex"
    Monomial.set_term_order("deglex")
    expect(Monomial.get_term_order).to eq "deglex"
    Monomial.set_term_order("degrevlex")
    expect(Monomial.get_term_order).to eq "degrevlex"
  end

  describe "#power_product" do
    it "power_product(3*x^2) = x^2" do
      expect(Monomial(c=3, p={"x"=>2}).power_product.to_s).to eq "x^(2)"
    end
    it "power_product(9*x^4) = x^4" do
      expect(Monomial(c=9, p={"x"=>4}).power_product.to_s).to eq "x^(4)"
    end
  end

  describe "#lcm, #gcd" do
    context "Given y^5, y^2" do
      m1 = Monomial(c=1, p={"y"=>5})
      m2 = Monomial(c=1, p={"y"=>2})

      it "lcm(y^5, y^2) = y^5" do
        expect(m1.lcm(m2).to_s).to eq m1.to_s
      end
      it "gcd(y^5, y^2) = y^2" do
        expect(m1.gcd(m2).to_s).to eq m2.to_s
      end
    end
  end

  describe "#to_s(format)" do
    context "Given 5x^4" do
      m = Monomial(c=5, p={"x"=>4})

      it "to_s(format=\"text\")= 5x^(4)" do
        expect(m.to_s("text")).to eq "5x^(4)"
      end
      it "to_s(format=\"tex\")= 5x^{4}" do
        expect(m.to_s("tex")).to eq "5x^{4}"
      end
      it "to_s(format=\"texm\")= $x^{4}$" do
        expect(m.to_s("texm")).to eq "$5x^{4}$"
      end
      it "to_s(format=\"prog\")= 5*x**4" do
        expect(m.to_s("prog")).to eq "5*x**(4)"
      end
    end
  end

end
