module QuotientFamilial
  module Matchers
    class Organizer
      attr_reader :interactors, :organizer
      private :organizer

      delegate :organized, to: :organizer
      delegate :to_sentence, to: :interactors, prefix: true

      def initialize(interactors)
        @interactors = interactors
      end

      alias_method :actual, :organized
      alias_method :expected, :interactors

      def matches?(organizer)
        @organizer = organizer
        organized == interactors
      end

      def description
        "organize #{interactors_to_sentence}"
      end

      def failure_message
        "expected #{organizer} to organize #{interactors_to_sentence}"
      end

      def failure_message_when_negated
        "expected #{organizer} to not organize #{interactors_to_sentence}"
      end

      def diffable?
        true
      end
    end

    def organize(interactors)
      Organizer.new(interactors)
    end
  end
end
