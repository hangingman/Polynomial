# coding: utf-8
require "poly_ruby/infinity"

RSpec.describe InfinityClass do
  skip "not working now..." do

    # TODO: following constants not defined
    #print PolyRuby::InfinityClass::Inf_IEEE754==1.0/0.0," x \n"
    #print PolyRuby::InfinityClass::Inf_IEEE754<=>1,"\n"
    #print PolyRuby::InfinityClass::NaN_IEEE754===0.0/0.0,"\n"

    # TODO: research and add correct specs
    # expect(InfinityClass.new(0.0)/InfinityClass.new(0.0)).to eq 0.0/0.0
    # print InfinityClass.new(0.0)/InfinityClass.new(0.0) <--- Indefinite
    # print 0.0/0.0===0.0/0.0,"\n"
    # print Inf_IEEE754<=>1,"\n"
    # print NaN_IEEE754<=>1,"\n"
    # print Indefinite<=>Indefinite,"\n"
    # print Infinity<Infinity,"\n"
    # print 3.between?(-Infinity,Infinity),"\n"
  end
end
