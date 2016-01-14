module SigaaParser
  class Prerequisites
    attr_reader :program, :courses

    def initialize(program)
      @program = program
      @courses = []
    end

    def add_course(course)
      @courses << course
    end

    def to_s
      @courses.join(', ')
    end
  end
end