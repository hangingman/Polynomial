# coding: utf-8
require "poly_ruby/number"


RSpec.describe Number do

  describe "#inv" do
    it "can return inverse" do
      p=7
      n=5
      expect(Number.inv(n,p)).to eq 3
    end
  end
  describe "#factorial" do
    it "can return factorial" do
      n=5
      expect(Number.factorial(n)).to eq 120
    end
  end
  context "Given some numbers" do
    n=[24,81,56]
    describe "#gcd2" do
      it "can return GCD" do
        gcd,*aj=Number.gcd2(n)
        expect(gcd).to eq 1
        expect(aj).to match_array [-190,57,-1]
      end
    end
    describe "#lcm" do
      it "can return LCM" do
        expect(Number.lcm(n)).to eq 4536
      end
    end
  end
  describe "#prime?" do
    it "can detect prime number" do
      expect(Number::prime?(10000000019)).to eq true
      expect(Number::prime?(10000000017)).to eq false
    end
  end
  describe "#nextPrime" do
    parameterized do
      where(:prime, :next_prime, size: 10) do
        [
          [10**10,      10000000019],
          [10000000019, 10000000033],
          [10000000033, 10000000061],
          [10000000061, 10000000069],
          [10000000069, 10000000097],
          [10000000097, 10000000103],
          [10000000103, 10000000121],
          [10000000121, 10000000141],
          [10000000141, 10000000147],
          [10000000147, 10000000207]
        ]
      end
      with_them do
        it "can return next prime number" do
          expect(Number.nextPrime(prime)).to eq next_prime
        end
      end
    end
  end
  describe "#factorize" do
    it "can return factorized numbers" do
      expect(Number.factor2s(Number.factorize(10000000017),"*")).to eq "3*3*3*7*7*7*1079797"
    end
  end
  describe "#i_to_notation_array, #i_to_notation_str, #i_to_notation_factorial, #notation_str_to_i" do
    n=14

    it "can return binary expansion of number(#1)" do
      b=2
      c=Number.i_to_notation_array(n,b)
      str=Number.i_to_notation_str(n,b)
      expect(c.reverse).to eq [1,1,1,0]
      expect(str).to eq "1110"
    end
    it "can return binary expansion of number(#2)" do
      b=3
      c=Number.i_to_notation_array(n,b)
      str=Number.i_to_notation_str(n,b)
      expect(c.reverse).to eq [1,1,2]
      expect(str).to eq "112"
    end
    it "can return binary expansion of factorized number" do
      c=Number.i_to_notation_factorial(n)
      c.shift
      expect(c.reverse).to eq [2,1,0]
    end
    it "can retrieve number from binary expansion" do
      str="1010"
      expect(Number.notation_str_to_i(str,2)).to eq 10
      expect(Number.notation_str_to_i(str,3)).to eq 30
    end
  end
end
