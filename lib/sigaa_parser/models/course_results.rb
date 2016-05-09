module SigaaParser
  class CourseResults
    attr_accessor :student, :progress
    attr_reader :results

    def initialize
      @results = []
      @progress = SigaaParser::CourseResults::Progress.new
    end

    def <<(result)
      @results << result
    end

    def semesters
      results.map(&:semester).uniq.sort
    end

    def average(options = {})
      average_up_to(semesters.last, options)
    end

    def average_up_to(semester, options = {})
      if !semesters.include?(semester)
        raise ArgumentError.new("Invalid semester #{semester}. Choose from #{self.semesters}")
      end

      courses = @results.select { |course| course.semester <= semester }

      if options[:approved_only]
        calculator = AverageCalculatorOnlyApproved.new(courses)
      else
        calculator = AverageCalculatorOnlyCompleted.new(courses)
      end

      calculator.calculate
    end
  end
end

