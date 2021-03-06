module SigaaParser
  # Course result data object
  class CourseResult < Course
    # Here semester refers to which semester this course result belongs to
    # Normally, semester on Course refers to which semester this course belongs in the curriculum
    attr_accessor :credits, :group, :grade, :situation

    def initialize(code, name, semester, workload, credits, group, grade, situation)
      super(code, name)
      @semester = semester
      @workload = workload
      @credits = credits
      @group = group
      @grade = grade
      @situation = situation
    end

    def to_s
      "#{semester} #{code} #{name} #{semester} #{workload} #{grade} #{situation}"
    end
  end
end
