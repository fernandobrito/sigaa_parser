module SigaaParser
  class Course
    # Require fields. Used for comparison
    attr_reader :code, :name, :semester

    # Optional fields
    attr_reader :workload, :type, :category

    def initialize(code, name, semester, workload = nil, type = nil, category = nil)
      @code = code
      @name = name
      @semester = semester.to_i

      @workload = workload if workload
      @type = type if type
      @category = category if category
    end

    def ==(course)
      (course.class == self.class && self.code == course.code &&
           self.name == course.name && self.semester == course.semester)
    end
  end
end