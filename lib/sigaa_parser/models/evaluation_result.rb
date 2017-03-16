module SigaaParser
  class EvaluationResult
    attr_accessor :professor, :course_name, :course_group, :course_schedule,
                  :department, :semester, :quantity_students, :scores,
                  :average_score, :std_dev

    def to_hash
      { professor: @professor, course_name: @course_name, course_group: @course_group,
        course_schedule: @course_schedule, department: @department, semester: @semester,
        quantity_students: @quantity_students, scores: @scores,
        average_score: @average_score, std_dev: @std_dev }
    end

    def to_json
      to_hash.to_json
    end
    
    def to_csv
      to_hash.values.join(',')
    end

    def self.csv_header
      to_hash.keys.map(&:to_s).join(',')
    end
  end
end
