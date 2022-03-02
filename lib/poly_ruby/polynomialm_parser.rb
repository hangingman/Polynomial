#require 'rubygems'
require "smithereen"
require "poly_ruby/monomial"


class EquationParserLexer < Smithereen::Lexer

  def initialize(s, options)
    @vars = options[:vars] || Monomial::VarOrder
    super(s)
  end

  def produce_next_token
    return nil if i >= length

    rest = s[i..-1]

    case rest
    when /\A\s+/m
      move $&.size
      produce_next_token
    when /\A\d+\.\d+/           then make_token(:ratnum,   $&)
    when /\A\d+/                then make_token(:num,      $&)
    when /\A\+/                 then make_token(:+,        $&)
    when /\A-/                  then make_token(:-,        $&)
    when /\A\^/                 then make_token(:'^',      $&)
    when /\A\*\*/               then make_token(:'**',     $&)
    when /\A\*/                 then make_token(:*,        $&)
    when /\A\//                 then make_token(:/,        $&)
    when /\A\(/                 then make_token(:'(',      $&)
    when /\A\)/                 then make_token(:')',      $&)
    when /\A[[:alpha:]]+/       then process_string($&)
    end
  end

  def process_string(str)
    if @vars.include? str
      make_token(:variable, str)
    else
      make_token(:name, str)
    end
  end

end

class EquationParserGrammar < Smithereen::Grammar


  def initialize(options)
    super()

    @@fns = options[:functions] || {
      'sin' => 'Math.sin',
      'cos' => 'Math.cos',
      'tan' => 'Math.tan',
      'sqrt' => 'Math.sqrt',
      'exp' =>  'Math.exp'
    }

    @@consts = options[:constants] || {
      'pi' => 'Math::PI',
      'e'  => 'Math::E'
    }

  end

  deftoken :ratnum, 1000 do
    def value
      @value ||= text.to_i
    end

    prefix { value }
  end

  deftoken :num, 1000 do
    def value
      @value ||= text.to_i
    end

    prefix { value }
  end

  deftoken :variable, 1000 do
    def value
      @value ||= Monomial(c=1, p={"#{text.to_s}"=>1})
    end

    prefix do
      value
    end

    infix do |left|
      left * value
    end
  end

  deftoken :name, 1000 do
    def value
      @value ||= text
    end

    prefix do
      v = value
      if @@consts.keys.include? v
        expr ||= @@consts[ v ]
      elsif @@fns.keys.include? v
        expr ||= v
      else
        raise ::Smithereen::ParseError.new("Unknown symbol", v)
      end

      expr
    end

    infix do |left|
      v = value
      if @@consts.keys.include? v
        expr ||= @@consts[ v ]
      elsif @@fns.keys.include? v
        expr ||= v
      else
        raise ::Smithereen::ParseError.new("Unknown symbol", v)
      end

      "#{left} * #{expr}"
    end

  end

  deftoken :+, 10 do
    infix do |left|
      right = expression(lbp)

      case [left.class,right.class]
      when [Integer, Integer]
        return Monomial(left + right)
      when [Integer, Monomial]
        return PolynomialM([Monomial(c=left), right])
      when [Monomial, Integer]
        return PolynomialM.new([left, Monomial(c=right)])
      when [PolynomialM, Integer]
        return left + right
      when [PolynomialM, Monomial]
        return left + right
      when [Monomial, Monomial]
        return PolynomialM.new([left, right])
      else
        raise "Parse error, type is #{left.class} + #{right.class}"
      end
    end
  end

  deftoken :-, 10 do
    prefix do
      expr = expression(lbp)
      expr.negate!
      return expr
    end

    infix {|left|
      right = expression(lbp)

      case [left.class,right.class]
      when [Integer, Integer]
        return Monomial(left - right)
      when [Integer, Monomial]
        return PolynomialM([Monomial(c=left), right.nagate])
      when [Monomial, Integer]
        return PolynomialM.new([left, Monomial(c=-right)])
      when [Monomial, Monomial]
        return PolynomialM.new([left, right.-@])
      when [PolynomialM, Integer]
        return PolynomialM.new([left, Monomial(c=-right)])
      else
        raise "Parse error, type is #{left.class} - #{right.class}"
      end
    }
  end

  deftoken :*, 20 do
    infix {|left|
      right = expression(lbp)

      case [left.class,right.class]
      when [Integer, Integer]
        return Monomial(left * right)
      when [Integer, Monomial]
        return Monomial(c=left*right.coeff, p=right.power)
      when [Monomial, Integer]
        return Monomial(left.coeff * right, left.power)
      when [PolynomialM, PolynomialM]
        return left * right

      else
        raise "Parse error, type is #{left.class} * #{right.class}"
      end
    }
  end

  deftoken :/, 20 do
    infix {|left|
      right = expression(lbp)

      case [left.class,right.class]
      when [Integer, Integer]
        return Monomial(left.quo(right))
      when [Integer, Monomial]
        return Monomial(c=left.quo(right.coeff), p=right.power)
      when [Monomial, Integer]
        return Monomial(left.coeff.quo(right), left.power)
      when [Monomial, Monomial]
        return left / right
      else
        raise "Parse error, type is #{left.class} / #{right.class}"
      end
    }
  end


  deftoken :"^", 30 do
    infix {|left|
      right = expression(lbp)

      case [left.class,right.class]
      when [Integer, Integer]
        return Monomial(c=left ** right)
      when [Monomial, Integer]
        return left ** right
      when [PolynomialM, Integer]
        return left ** right
      else
        raise "Parse error, type is #{left.class} ** #{right.class}"
      end
    }
  end

  deftoken :"**", 30 do
    infix {|left|
      right = expression(lbp)

      case [left.class,right.class]
      when [Integer, Integer]
        return Monomial(c=left ** right)
      when [Monomial, Integer]
        return left ** right
      when [PolynomialM, Integer]
        return left ** right
      else
        raise "Parse error, type is #{left.class} ** #{right.class}"
      end
    }
  end

  deftoken :'(', 50 do
    prefix do
      in_paren = expression.tap{ advance_if_looking_at! :')' }
      return in_paren
    end

    infix do |left|

      raise ::Smithereen::ParseError.new("Expected a function name", left) unless String === left

      if looking_at? :name
        args = delimited_sequence(:'(',:')') { expression(0) }
        arg = if @@fns.keys.include? left
                @@fns[left] + '(' + args[0] + ')'
              else
                raise ::Smithereen::ParseError.new("Unrecognized function", left)
              end
      elsif looking_at? :variable or looking_at? :num or looking_at? :ratnum or looking_at? :name
        arg = expression(lbp)
        advance_if_looking_at(:')') or raise ::Smithereen::ParseError.new("Missing closing parenthesis", nil)
        if @@fns.keys.include? left
          @@fns[left] + '(' + arg + ')'
        else
          raise ::Smithereen::ParseError.new("Unrecognized function", left)
        end
      else
        raise ::Smithereen::ParseError.new("Unknown symbol", left)
      end

    end
  end

  deftoken :')', 0

end

class PolynomialMParser < Smithereen::Parser
  def initialize(s, options = {})
    super(EquationParserGrammar.new(options), EquationParserLexer.new(s, options))
  end

  def parse
    parsed = super()
    case parsed
    when Integer
      return PolynomialM(parsed)
    when Monomial
      return PolynomialM(parsed)
    when PolynomialM
      return parsed
    else
      raise "Parse error, type is #{parsed.class}:#{parsed}"
    end
    return parsed
  end
end
