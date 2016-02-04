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
  end
end