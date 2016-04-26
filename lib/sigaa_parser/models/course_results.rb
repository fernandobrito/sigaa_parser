module SigaaParser
  class CourseResults
    attr_accessor :student
    attr_reader :results

    def initialize
      @results = []
    end

    def <<(result)
      @results << result
    end

    def semesters
      results.map(&:semester).uniq.sort
    end

    def average_up_to(semester)
      if (! semesters.include?(semester))
        raise ArgumentError.new("Invalid semester #{semester}. Choose from #{self.semesters}")
      end

      courses = @results.select{ |course| course.semester <= semester }
      total = courses.map{ |course| course.grade.to_f * course.credits.to_i }.inject(:+)
      total_credits = courses.map{ |course| course.credits.to_i }.inject(:+)

      total / total_credits
    end
  end
end