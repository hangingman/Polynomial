# coding: utf-8
require "poly_ruby/pqueue"


RSpec.describe PQueue do

  context "Given some elements to priority queue (PQueue)" do
    pq = PQueue.new(proc { |x, y| x > y })
    pq.push(2)
    pq.push(3)
    pq.push(4)
    pq.push(3)
    pq.push(2)
    pq.push(4)

    it "can return size and elements as Array" do
      expect(pq.size).to eq 6
      expect(pq.to_a).to eq [2, 2, 3, 3, 4, 4]
    end
    it "can keep inserted order" do
      ans = []
      pq.each_with_index{|e,_| ans << e}
      expect(ans).to eq [4, 3, 4, 2, 2, 3]
    end
    it "will pop-out with specified priority" do
      expected_values = [4, 4, 3, 3, 2, 2]
      idx = 0
      pq.each_pop do |e|
        expect(expected_values[idx]).to eq e
        idx += 1
      end
    end
  end
end
