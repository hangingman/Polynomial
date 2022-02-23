# coding: utf-8
require "poly_ruby/polynomial"
require "poly_ruby/gbasei1"

RSpec.describe GBaseI1 do
  skip "testGBaseI1: not working now..." do
    print "--- Grobner basis in Z[x]---\n"
    f1 = Polynomial("2x^(4)-2x^(2)+8x+10")
    f2 = Polynomial("3x^(4)+12x+15")
    f3 = Polynomial("2x^(5)+12x^(4)-2x^(3)+10x^(2)+58x+62")
    flist = [f1, f2, f3]
    print "basis\n"
    flist.each { |f| printf "%s\n", f }
    flist2 = GBaseI1.getGBaseI1(flist)
    print "Groebner basis\n"
    flist2.each { |f| printf "%s\n", f }
  end
end
