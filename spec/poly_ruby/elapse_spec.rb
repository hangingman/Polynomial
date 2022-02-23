# coding: utf-8
require "poly_ruby/elapse"


RSpec.describe Elapse do
  skip "skip Elapse" do
    Elapse::time { 1000.times { x = 9 ** 1111 } }.print
    Elapse::new { 1000.times { x = 9 ** 1111 } }.print

    exit
    t = Elapse::new

    t.mark # mark point 0
    1000.times { x = 9 ** 3333 }
    t.mark # mark point 1
    t.print # elapsed time between point 0 to 1

    t.mark # mark point 2
    1000.times { x = 9 ** 5555 }
    t.mark # mark point 3
    t.print # elapsed time between point 2 to 3

    t.print(0, 3) # elapsed time between point 0 to 3

    exit
    ## Example

    a = 9
    b = 10000
    ite = 100

    Elapse::time { ite.times { x = a ** b } }.print

    exit

    t = Elapse::new
    t.mark # mark point 0
    ite.times { x = a ** b }
    t.mark # mark point 1
    t.print # elapsed time between point 0 to 1
    t.mark # mark point 2
    ite.times { x = a ** b }
    t.mark # mark point 3
    t.print # elapsed time between point 2 to 3
    t.print(0, 3) # elapsed time between point 0 to 3
  end
end
