module SigaaParser
  class Student
    attr_reader :id, :name, :program

    def initialize(id, name, program)
      @id = id
      @name = name
      @program = program
    end

    def ==(student)
      (student.class == self.class && self.id == student.id &&
          self.name == student.name && self.program == student.program)
    end
  end
end