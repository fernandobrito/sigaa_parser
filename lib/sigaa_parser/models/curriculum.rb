module SigaaParser
  class Curriculum
    attr_reader :code, :name, :semesters

    attr_accessor :courses

    def initialize(code, name, semesters)
      @code = code
      @name = name
      @semesters = semesters

      @courses = []
    end
  end
end