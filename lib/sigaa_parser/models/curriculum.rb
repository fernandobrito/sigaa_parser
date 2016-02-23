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

    def to_hash_short
      { id: @code, name: @name, faculty: @faculty, semesters: @semesters.to_i }
    end

    def to_hash
      courses = @courses.map { |c| c.to_hash }

      to_hash_short.merge(courses: courses)
    end
  end
end