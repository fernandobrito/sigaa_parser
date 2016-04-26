module SigaaParser
  class Student
    attr_reader :id, :name, :curriculum

    def initialize(id, name, curriculum)
      @id = id
      @name = name
      @curriculum = curriculum
    end

    def ==(student)
      (student.class == self.class && self.id == student.id &&
          self.name == student.name && self.curriculum == student.curriculum)
    end

    def to_s
      "#{id} #{name}"
    end
  end
end