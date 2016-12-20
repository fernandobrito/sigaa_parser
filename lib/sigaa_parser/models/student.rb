module SigaaParser
  # Student data object
  class Student
    attr_reader :id, :name, :program

    def initialize(id, name, program)
      @id = id
      @name = name
      @program = program
    end

    def ==(other)
      (other.class == self.class && id == other.id &&
          name == other.name && program == other.program)
    end

    def to_s
      "#{id} #{name}"
    end
  end
end
