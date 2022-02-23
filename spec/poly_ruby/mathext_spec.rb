# coding: utf-8
require "poly_ruby/mathext"


RSpec.describe MathExt do

  describe "MathExt" do

    context "x = PI / 4" do
      x = Math::PI / 4

      it "sin(x)= 0.7071067811865475(Math) 0.7071067811865475(MathExt) diff:0.0" do
        s0 = Math.sin(x); s1 = MathExt.sin(x)
        expect(s0).to eq 0.7071067811865475
        expect(s1).to eq 0.7071067811865475
        expect(s0-s1).to eq 0.0
      end
      it "cos(x)= 0.7071067811865476(Math) 0.7071067811865475(MathExt) diff:1.1102230246251565e-16" do
        s0 = Math.cos(x); s1 = MathExt.cos(x)
        expect(s0).to eq 0.7071067811865476
        expect(s1).to eq 0.7071067811865475
        expect(s0-s1).to eq 1.1102230246251565e-16
      end
      it "tan(x)= 0.9999999999999999(Math) 1.0(MathExt) diff:-1.1102230246251565e-16" do
        s0 = Math.tan(x); s1 = MathExt.tan(x)
        expect(s0).to eq 0.9999999999999999
        expect(s1).to eq 1.0
        expect(s0-s1).to eq -1.1102230246251565e-16
      end
      it "atan(x)= 0.6657737500283538(Math) 0.6657737500283539(MathExt) diff:-1.1102230246251565e-16" do
        s0 = Math.atan(x); s1 = MathExt.atan(x)
        expect(s0).to eq 0.6657737500283538
        expect(s1).to eq 0.6657737500283539
        expect(s0-s1).to eq -1.1102230246251565e-16
      end
      it "log(x)= -0.2415644752704905(Math) -0.24156447527049052(MathExt) diff:2.7755575615628914e-17" do
        s0 = Math.log(x); s1 = MathExt.log(x)
        expect(s0).to eq -0.2415644752704905
        expect(s1).to eq -0.24156447527049052
        expect(s0-s1).to eq 2.7755575615628914e-17
      end
      it "exp(x)= 2.1932800507380152(Math) 2.1932800507380157(MathExt) diff:-4.440892098500626e-16" do
        s0 = Math.exp(x); s1 = MathExt.exp(x)
        expect(s0).to eq 2.1932800507380152
        expect(s1).to eq 2.1932800507380157
        expect(s0-s1).to eq -4.440892098500626e-16
      end
      it "sqrt(x)= 0.8862269254527579(Math) 0.8862269254527579(MathExt) diff:0.0" do
        s0 = Math.sqrt(x); s1 = MathExt.sqrt(x)
        expect(s0).to eq 0.8862269254527579
        expect(s1).to eq 0.8862269254527579
        expect(s0-s1).to eq 0.0
      end
    end
    context "x = 2.0" do
      x = 2.0

      it "sqrt(x)= 1.4142135623730951(Math) 1.414213562373095(MathExt) diff:2.220446049250313e-16" do
        s0 = Math.sqrt(x); s1 = MathExt.sqrt(x)
        expect(s0).to eq 1.4142135623730951
        expect(s1).to eq 1.414213562373095
        expect(s0-s1).to eq 2.220446049250313e-16
      end
      it "(sqrt(x))^2= 2.0000000000000004(Math) 1.9999999999999996(MathExt) diff:-4.440892098500626e-16 4.440892098500626e-16" do
        s0 = Math.sqrt(x); s1 = MathExt.sqrt(x)
        t0 = s0 * s0; t1 = s1 * s1
        expect(t0).to eq 2.0000000000000004
        expect(t1).to eq 1.9999999999999996
        expect(x-t0).to eq -4.440892098500626e-16
        expect(x-t1).to eq 4.440892098500626e-16
      end
    end
    context "x = 1.0" do
      x = 1.0

      it "atan(x)= 0.7853981633974483(Math) 0.7853981633974483(MathExt) diff:0.0" do
        s0 = Math.atan(x); s1 = MathExt.atan(x)
        expect(s0).to eq 0.7853981633974483
        expect(s1).to eq 0.7853981633974483
        expect(s0-s1).to eq 0.0
      end
      it "tan(atan(x))= 0.9999999999999999(Math) 1.0(MathExt) diff:1.1102230246251565e-16 0.0" do
        s0 = Math.atan(x); s1 = MathExt.atan(x)
        t0 = Math.tan(s0); t1 = MathExt.tan(s1)
        expect(t0).to eq 0.9999999999999999
        expect(t1).to eq 1.0
        expect(x-t0).to eq 1.1102230246251565e-16
        expect(x-t1).to eq 0.0
      end
    end
    context "x = 1.4" do
      x = 1.4

      it "log(x)= 0.3364722366212129(Math) 0.3364722366212128(MathExt) diff:1.1102230246251565e-16" do
        s0 = Math.log(x); s1 = MathExt.log(x)
        expect(s0).to eq 0.3364722366212129
        expect(s1).to eq 0.3364722366212128
        expect(s0-s1).to eq 1.1102230246251565e-16
      end
      it "exp(log(x))= 1.4(Math) 1.4(MathExt) diff:0.0 0.0" do
        s0 = Math.log(x); s1 = MathExt.log(x)
        t0 = Math.exp(s0); t1 = MathExt.exp(s1)
        expect(t0).to eq 1.4
        expect(t1).to eq 1.4
        expect(x-t0).to eq 0.0
        expect(x-t1).to eq 0.0
      end
    end

    it "PI == 3.14159265358979311600" do
      expect(Math::PI).to eq 3.14159265358979311600
      expect(MathExt::PI).to eq 3.14159265358979311600
    end
    it "sqrt(PI)= 1.7724538509055159" do
      expect(MathExt.sqrt(Math::PI)).to eq 1.7724538509055159
    end

    describe "#gamma" do
      parameterized do
        where(:x, :answer, size: 4) do
          [
            [2  , 2],
            [3  , 6],
            [4  , 24],
            [0.5, 1.77245385090514],
          ]
        end
        with_them do
          it { expect(MathExt.gamma(x)).to eq answer }
        end
      end
    end
  end
end
