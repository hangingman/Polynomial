# coding: utf-8
require "poly_ruby/polynomialm"
require "poly_ruby/gbasei"


RSpec.describe GBaseI do
  skip "not working now..." do
    print "--- Grobner basis in Z[x,y,... ]---\n"
    print "--- sample 1---\n"
    f1 = PolynomialM("2x+3y+3")
    f2 = PolynomialM("x+5y+2")
    gb = GBaseI.getGBaseI([f1, f2])
    print gb.join(", "), "\n"

    print "--- sample 2---\n"
    f1 = PolynomialM("2x+3y+3")
    f2 = PolynomialM("x+5y+2")
    f3 = PolynomialM("x*y-1")
    gb = GBaseI.getGBaseI([f1, f2, f3])
    print gb.join(", "), "\n"

    # sample from
    #    William W.Adams, Philippe Loustaunau
    #    "An Introduction to Groebner Bases",
    #    AMS GSM(Graduale Study in Mathematics) vol.3

    print "--- sample 4.5.5 ---\n"
    f1 = PolynomialM("3x^2*y+7y")
    f2 = PolynomialM("4x*y^2-5x")
    gb = GBaseI.getGBaseI([f1, f2])
    print gb.join(", "), "\n"

    print "--- sample ex.4.5.5a ---\n"
    Monomial.setVarOrder(["y", "x"])
    Monomial.set_term_order("lex")
    f1 = PolynomialM("2x*y-x")
    f2 = PolynomialM("3y-x^2")
    gb = GBaseI.getGBaseI([f1, f2])
    print gb.join(", "), "\n"

    print "--- sample ex.4.5.5b ---\n"
    Monomial.setVarOrder
    Monomial.set_term_order("deglex")
    f1 = PolynomialM("3x^2y-3y*z+y")
    f2 = PolynomialM("5x^2z-8z^2")
    gb = GBaseI.getGBaseI([f1, f2])
    print gb.join(", "), "\n"

    print "--- sample ex.4.5.5c ---\n"
    Monomial.setVarOrder
    Monomial.set_term_order("lex")
    f1 = PolynomialM("6x^2+y^2")
    f2 = PolynomialM("10x^2y+2x*y")
    gb = GBaseI.getGBaseI([f1, f2])
    print gb.join(", "), "\n"
  end
end
