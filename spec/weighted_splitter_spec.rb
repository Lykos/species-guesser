$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'spec'))

require 'weighted_splitter'

include SpeciesGuesser

describe WeightedSplitter do

  describe ".weighted_split" do

    it "should return an empty array for empty input" do
      expect(WeightedSplitter::weighted_split([]) { |e| e }).to be_empty
    end

    it "should return half of the elements for an even number of elements with zero weights" do
      expect(WeightedSplitter::weighted_split([0, 0, 0, 0]) { |e| e }).to contain_exactly(0, 0)
    end

    it "should return one more than half of the elements for an uneven number of elements with zero weights" do
      expect(WeightedSplitter::weighted_split([0, 0, 0, 0, 0]) { |e| e }).to contain_exactly(0, 0, 0)
    end

    it "should return half of the elements for an even number of elements with equal weights" do
      expect(WeightedSplitter::weighted_split([2, 2, 2, 2]) { |e| e }).to contain_exactly(2, 2)
    end

    it "should return one more than half of the elements for an uneven number of elements with equal weights" do
      expect(WeightedSplitter::weighted_split([2, 2, 2, 2, 2]) { |e| e }).to contain_exactly(2, 2, 2)
    end

    it "should return half of the elements for an even number of elements with equal non-zero weights and zero weights" do
      expect(WeightedSplitter::weighted_split([2, 2, 2, 2, 0, 0]) { |e| e }).to contain_exactly(2, 2, 0)
    end

    it "should return half of the non-zero weight elements and one more than half of the zero weight elements for an even number of elements with equal non-zero weights and an uneven number of elements with zero weights" do
      expect(WeightedSplitter::weighted_split([2, 2, 2, 2, 0, 0, 0]) { |e| e }).to contain_exactly(2, 2, 0, 0)
    end

    it "should return one more than half of the non-zero weight elements for an uneven number of elements with equal non-zero weights and zero weights" do
      expect(WeightedSplitter::weighted_split([2, 2, 2, 2, 2, 0, 0]) { |e| e }).to contain_exactly(2, 2, 2)
    end

    it "should return one of each kind in case of several pairs" do
      expect(WeightedSplitter::weighted_split([2, 2, 1, 1, 0, 0]) { |e| e }).to contain_exactly(2, 1, 0)
    end

    it "should return the one dominating weight alone" do
      expect(WeightedSplitter::weighted_split([5, 1, 1, 0, 0]) { |e| e }).to contain_exactly(5)
    end

  end

end
