module SpeciesGuesser

  class WeightedSplitter

    # Returns a subarray of a given array and a given weight function such that the subarray has more than half of the weight
    # and as close to half the weight as possible.
    # +array+:: The array of which we should choose half the weight of.
    # +weight_function+:: A function that returns the weight of an element. This will be called once per element.
    def self.weighted_split(array, &weight_function)
      weights = array.collect { |e| weight_function.call(e) }
      min_weight = weights.inject(0) { |a, b| a + b } / 2.0
      weighted_array = array.zip(weights)
      zero_weighted, nonzero_weighted = weighted_array.partition { |element_weight| element_weight[1] == 0 }
      reachable_weights = {0 => []}
      nonzero_weighted.shuffle.each do |element_weight|
        element, weight = element_weight
        new_reachable_weights = {}
        reachable_weights.each_pair do |reachable_weight, elements|
          if reachable_weight < min_weight
            new_reachable_weight = reachable_weight + weight
            unless reachable_weights.has_key?(new_reachable_weight)
              new_reachable_weights[new_reachable_weight] = elements + [element]
            end
          end
        end
        reachable_weights.merge!(new_reachable_weights)
      end
      best_weight = 0
      best_elements = []
      reachable_weights.each_pair do |weight, elements|
        if weight >= min_weight and (best_weight < min_weight or best_weight > weight)
          best_weight = weight
          best_elements = elements
        end
      end
      if best_weight < min_weight
        raise "Impossible to get more than half of the weights in an array. There must be something wrong with the weight function."
      end
      if best_weight == min_weight
        best_elements += zero_weighted.sample((zero_weighted.length + 1) / 2).map { |e| e.first }
      end
      best_elements
    end

  end

end
