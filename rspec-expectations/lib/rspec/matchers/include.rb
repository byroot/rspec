module RSpec
  module Matchers
    class Include
      include BaseMatcher

      def initialize(*expected)
        super(expected)
      end

      def matches?(actual)
        perform_match(:all?, :all?, super(actual), expected)
      end

      def does_not_match?(actual)
        perform_match(:none?, :any?, super(actual), expected)
      end

      def description
        "include#{expected_to_sentence}"
      end

    private

      def perform_match(predicate, hash_predicate, actual, expected)
        expected.send(predicate) do |expected|
          if comparing_hash_values?(actual, expected)
            expected.send(hash_predicate) {|k,v| actual[k] == v}
          elsif comparing_hash_keys?(actual, expected)
            actual.has_key?(expected)
          else
            actual.include?(expected)
          end
        end
      end

      def comparing_hash_keys?(actual, expected)
        actual.is_a?(Hash) && !expected.is_a?(Hash)
      end

      def comparing_hash_values?(actual, expected)
        actual.is_a?(Hash) && expected.is_a?(Hash)
      end
    end
  end
end
