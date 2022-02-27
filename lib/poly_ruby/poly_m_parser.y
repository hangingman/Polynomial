class PolynomialMParser

start polynomial

prechigh
  nonassoc UMINUS
  left     '*' '/'
  left     '+' '-'
  right    '='
preclow

rule

polynomial:
  monomials                        { result = PolyM.new(val[0]) }
  | '(' monomials ')' POW number   { result = PolyM.new(val[1]) ** val[4].to_i }
  | polynomial '*' monomials       { result = val[0] * PolyM.new(val[2]) }
  | polynomial '/' monomials       { result = val[0] / PolyM.new(val[2]) }

monomials:
  monomial                         { result = [val[0]] }
  | '(' monomials ')'              { result = val[1] }
  | monomial '*' '(' monomials ')' { result = val[3].map{|m| m * val[0]} }
  | monomial '/' '(' monomials ')' { result = val[3].map{|m| val[0] / m} }
  | '-' monomials                  { result = val[1].map(&:negate!) }
  | monomials '+' monomial         { result = val[0].append(val[2]) }
  | monomials '-' monomial         { result = val[0].append(val[2].negate!) }

monomial:
  number                           { result = Monomial(c=val[0]) }
  | variable                       { result = Monomial(c=1, p={"#{val[0]}"=>1}) }
  | monomial '*' monomial          { result = val[0] * val[2] }
  | monomial '/' monomial          { result = val[0] / val[2] }
  | monomial POW number            { result = val[0].clone ** val[2] }
  #| '(' monomial ')'              { result = val[1] }

number:
  DIGITS                          { result = val[0].to_i }
  | DIGITS number_loop

number_loop:
  DIGITS number_loop

variable:
  LETTERS

end

---- header
require "strscan"
require "poly_ruby/monomial"

---- inner
def parse(str)
  @yydebug = true
  @tokens = []

  s = StringScanner.new(str)

  until s.eos?
    case
    when s.scan(/\s+/)
    when s.scan(/\+/)
      @tokens.push ['+', s.matched]
    when s.scan(/\-/)
      @tokens.push ['-', s.matched]
    when s.scan(/\*\*|\^/)
      @tokens.push [:POW, s.matched]
    when s.scan(/\*/)
      @tokens.push ['*', s.matched]
    when s.scan(/\//)
      @tokens.push ['/', s.matched]
    when s.scan(/\(/)
      @tokens.push ['(', s.matched]
    when s.scan(/\)/)
      @tokens.push [')', s.matched]
    when s.scan(/\d+/)
      @tokens.push [:DIGITS, s.matched]
    when s.scan(/[a-zA-Z]+/)
      @tokens.push [:LETTERS, s.matched]
    when s.scan(/.|\n/o)
      @tokens.push [s.matched, s.matched]
    else
      raise "scanner error"
    end
  end
  @tokens.push [false, '$end']
  #p @tokens

  do_parse
end

def next_token
  @tokens.shift
end

---- footer
PolyMParser = PolynomialMParser
