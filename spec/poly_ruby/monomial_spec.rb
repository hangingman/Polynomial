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
