module SigaaParser
  class Course
    # Require fields. Used for comparison
    attr_reader :code

    # Optional fields
    attr_reader :name, :semester, :workload, :type, :category

    # See Prerequesites model
    attr_accessor :prerequisites

    def initialize(code, name = nil, semester = nil, workload = nil, type = nil, category = nil)
      @code = code

      @prerequisites = []

      @name = name if name
      @semester = semester.to_i if semester
      @workload = workload if workload
      @type = type if type
      @category = category if category
    end

    def add_prerequisites(prerequisites)
      @prerequisites << prerequisites
    end

    def prerequisites_for(code)
      @prerequisites.select{ |pre| pre.curriculum.include?(code) }
    end

    def prerequisites_courses
      if @prerequisites && @prerequisites.size > 0
        @prerequisites.first.courses
      else
        []
      end
    end

    def ==(course)
      (course.class == self.class && self.code == course.code)
    end

    def to_s
      # "#{@code} - #{@name}"
      "#{code}"
    end

    def to_hash
      { code: @code, name: @name, category: @category, semester: @semester.to_i,
        workload: @workload, type: @type, prerequisites: prerequisites_courses }
    end
  end
end