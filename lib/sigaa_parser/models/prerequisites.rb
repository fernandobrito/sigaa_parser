module SigaaParser
  # A course has prerequesits according to a curriculum
  class Prerequisites
    attr_reader :curriculum, :program, :courses

    def initialize(curriculum_name)
      # "CIÊNCIAS DA COMPUTAÇÃO (BACHARELADO)/CI - João Pessoa - 2006.1 - 162006"

      @curriculum = curriculum_name.split(' - ').last
      @program = curriculum_name.split(' - ')[0...-2].join(' - ')
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