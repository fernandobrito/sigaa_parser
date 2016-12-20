module SigaaParser
  # Template design pattern to calculate the average over
  # course results. Sub classes can override the filter method,
  # for example
  class AverageCalculatorTemplate
    def initialize(results)
      @results = results
      @average = nil
    end

    def calculate
      filter_results
      do_calculations
      format_output
    end

    protected

    def filter_results
      nil
    end

    def do_calculations
      total = @results.map { |course| course.grade.to_f * course.credits.to_i }.inject(:+)
      total_credits = @results.map { |course| course.credits.to_i }.inject(:+)

      @average = total / total_credits
    end

    def format_output
      @average.round(2)
    end
  end

  # Does not include "REPROVADO, MATRICULADO, REP. FALTA"
  class AverageCalculatorOnlyApproved < AverageCalculatorTemplate
    protected

    def filter_results
      situations = %w(APROVADO DISPENSADO)
      @results.select! { |result| situations.include?(result.situation) }
    end
  end

  # Does not include "MATRICULADO"
  class AverageCalculatorOnlyCompleted < AverageCalculatorTemplate
    protected

    def filter_results
      situations = %w(APROVADO DISPENSADO REPROVADO REP.\ FALTA)
      @results.select! { |result| situations.include?(result.situation) }
    end
  end
end
