module SigaaParser
  class Course
    # Require fields. Used for comparison
    attr_reader :code

    # Optional fields
    attr_reader :name, :semester, :workload, :type, :category, :prerequisites

    def initialize(code, name = nil, semester = nil, workload = nil, type = nil, category = nil)
      @code = code

      @prerequisites = []

      @name = name if name
      @semester = semester.to_i if semester
      @workload = workload if workload
      @type = type if type
      @category = category if category
    end

    def add_prerequisite(course)
      @prerequisites << course
    end

    def ==(course)
      (course.class == self.class && self.code == course.code)
    end
  end
end