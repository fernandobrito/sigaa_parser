module SigaaParser
  class Curriculum
    attr_reader :code, :name, :semesters, :faculty

    attr_accessor :courses

    def initialize(code, name, semesters, faculty)
      @code = code
      @name = name
      @semesters = semesters
      @faculty = faculty

      @courses = []
    end

    def to_json_short
      { code: @code, name: @name, faculty: @faculty, semesters: @semesters.to_i }
    end

    def to_hash
      courses = @courses.map { |c| c.to_hash }

      to_json_short.merge(courses: courses)
    end
  end
end