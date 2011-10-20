module RSpec
  module Matchers
    # Used _internally_ as a base class for matchers that ship with
    # rspec-expectations.
    #
    # == Warning
    #
    # This class is for internal use, and subject to change without notice.  We
    # strongly recommend that you do not base your custom matchers on this
    # class. If/when this changes, we will announce it and remove this warning.
    module BaseMatcher
      include RSpec::Matchers::Pretty

      attr_reader :actual, :expected

      def initialize(expected=nil)
        @expected = expected
      end

      def matches?(actual)
        @actual = actual
      end

      def does_not_match?(actual)
        @actual = actual
      end

      def failure_message_for_should
        "expected #{actual.inspect} to #{name_to_sentence}#{expected_to_sentence}"
      end

      def failure_message_for_should_not
        "expected #{actual.inspect} not to #{name_to_sentence}#{expected_to_sentence}"
      end

      def description
        expected ? "#{name_to_sentence} #{expected.inspect}" : name_to_sentence
      end

      def diffable?
        false
      end
    end
  end
end
