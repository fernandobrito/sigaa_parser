module SigaaParser
  class CourseResults
    # Calculates progress and percentage over
    # given sets
    class ProgressItem
      attr_reader :completed, :total

      def initialize(completed = 0, total = 0)
        set(completed, total)
      end

      def set(completed, total)
        @completed = completed
        @total = total
      end

      def percentage_completed
        (@completed / @total.to_f * 100).round(2)
      end
    end

    # Progress of course results by course categories
    class Progress
      # Compulsory is actually grouping "Básicas Profissionais" e "Complementares Obrigatórias"
      attr_reader :total, :compulsory, :flexible, :optional

      def initialize
        @total = CourseResults::ProgressItem.new
        @compulsory = CourseResults::ProgressItem.new
        @optional = CourseResults::ProgressItem.new
        @flexible = CourseResults::ProgressItem.new
      end
    end
  end
end
