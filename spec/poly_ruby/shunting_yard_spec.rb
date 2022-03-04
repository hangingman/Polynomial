# coding: utf-8
require "poly_ruby/shunting_yard"


RSpec.describe ShutingYard do


  describe "#op_preced" do
    parameterized do
      where(:c, :ans, size: 7) do
        [
          ["^", 4],
          ["*", 3],
          ["/", 3],
          ["%", 3],
          ["+", 2],
          ["-", 2],
          ["=", 1],
        ]
      end
      with_them do
        it do
          @shuting_yard = ShutingYard.new
          expect(@shuting_yard.op_preced(c)).to eq ans
        end
      end
    end
  end

  describe "#op_left_assoc" do
    parameterized do
      where(:c, :ans, size: 7) do
        [
          ["^", false],
          ["*", true],
          ["/", true],
          ["%", true],
          ["+", true],
          ["-", true],
          ["=", false],
        ]
      end
      with_them do
        it do
          @shuting_yard = ShutingYard.new
          expect(@shuting_yard.op_left_assoc(c)).to eq ans
        end
      end
    end
  end

  describe "#op_arg_count" do
    parameterized do
      where(:c, :ans, size: 7) do
        [
          ["+", 2],
          ["-", 2],
          ["*", 2],
          ["/", 2],
          ["^", 1],
          ["%", 2],
          ["=", 2],
        ]
      end
      with_them do
        it do
          @shuting_yard = ShutingYard.new
          expect(@shuting_yard.op_arg_count(c)).to eq ans
        end
      end
    end
  end

  describe "#tokenize" do

    it "toknize formula containing numbers" do
      tokens = ShutingYard.new.tokenize("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")
      expect(tokens).to eq [[:NUM, "3"],
                            [:OP, "+"],
                            [:NUM, "4"],
                            [:OP, "*"],
                            [:NUM, "2"],
                            [:OP, "/"],
                            ["(", "("],
                            [:NUM, "1"],
                            [:OP, "-"],
                            [:NUM, "5"],
                            [")", ")"],
                            [:OP, "^"],
                            [:NUM, "2"],
                            [:OP, "^"],
                            [:NUM, "3"]]
    end

    it "toknize formula containing variables" do
      tokens = ShutingYard.new.tokenize("x + y * z / ( p - q ) ** k ** t")
      expect(tokens).to eq [[:VAR, "x"],
                            [:OP, "+"],
                            [:VAR, "y"],
                            [:OP, "*"],
                            [:VAR, "z"],
                            [:OP, "/"],
                            ["(", "("],
                            [:VAR, "p"],
                            [:OP, "-"],
                            [:VAR, "q"],
                            [")", ")"],
                            [:OP, "**"],
                            [:VAR, "k"],
                            [:OP, "**"],
                            [:VAR, "t"]]
    end
  end

  describe "#parse" do

    it "'3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3' => '3 4 2 * 1 5 - 2 3 ^ ^ / +'" do
      @shuting_yard = ShutingYard.new
      tokens = @shuting_yard.tokenize("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3")
      prn = @shuting_yard.parse(tokens).join(" ")
      expect(prn).to eq "3 4 2 * 1 5 - 2 3 ^ ^ / +"
    end

    it "'x + y * z / ( p - q ) ** k ** t' => 'x y z * p q - k t ** ** / +'" do
      @shuting_yard = ShutingYard.new
      tokens = @shuting_yard.tokenize("x + y * z / ( p - q ) ** k ** t")
      prn = @shuting_yard.parse(tokens).join(" ")
      expect(prn).to eq "x y z * p q - k t ** ** / +"
    end

    it "'2*(2*x-3)^3' => '2 2 x * 3 - 3 ^ *'" do
      @shuting_yard = ShutingYard.new
      tokens = @shuting_yard.tokenize("2*(2*x-3)^3")
      prn = @shuting_yard.parse(tokens).join(" ")
      expect(prn).to eq "2 2 x * 3 - 3 ^ *"
    end
  end
end
