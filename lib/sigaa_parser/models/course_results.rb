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

    def average_up_to(semester, options = {})
      if (! semesters.include?(semester))
        raise ArgumentError.new("Invalid semester #{semester}. Choose from #{self.semesters}")
      end

      if options[:approved_only]
        situations = %w{APROVADO DISPENSADO}
      else
        situations = %w{APROVADO DISPENSADO REPROVADO REP.\ FALTA}
      end

      courses = @results.select { |course| course.semester <= semester }
      courses.select! { |course| situations.include?(course.situation) }

      total = courses.map { |course| course.grade.to_f * course.credits.to_i }.inject(:+)
      total_credits = courses.map { |course| course.credits.to_i }.inject(:+)

      (total / total_credits).round(2)
    end
  end
end