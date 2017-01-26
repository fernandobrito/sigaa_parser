require 'pdf-reader'

module SigaaParser
  # Parses a PDF file generated from SIGAA with the Transcript of Records
  #  of a given student.
  # Usage: Initialize an instance passing the file to the constructor. File
  #  is automatically parsed and data is accessed via attributes.
  class TranscriptParser
    class InvalidFileExtension < RuntimeError ; end
    class InvalidFileFormat < RuntimeError ; end
    class ParsingError < RuntimeError ; end

    VALID_EXTENSION = '.pdf'.freeze

    # @!attribute [r] courses
    attr_reader :course_results

    # @raise [InvalidFileExtension] file is not .pdf
    # @raise [InvalidFileFormat] file is not a transcript of records from SIGAA
    # @raise [ParsingError]
    def initialize(file)
      @course_results = SigaaParser::CourseResults.new
      @file = file

      verify_file_extension
      convert_to_rows
      verify_file_format

      parse_student
      parse_results
      parse_progress
    end

    protected

    def parse_student
      student_name = @rows.find { |line| line.include?('Nome:') }.split(':').last.strip
      student_id = @rows.find { |line| line.include?('Matrícula:') }.split('Matrícula:').last.strip
      # student_curriculum_code = @rows.find { |line| line.include?('Currículo:') }[/\d+/]
      student_program_name = @rows.find { |line| line.include?('Curso:') }
          .split(':').last.split('-')[0..1].join('-').strip

      student = SigaaParser::Student.new(student_id, student_name, student_program_name)

      @course_results.student = student
    end

    def parse_results
      grades_rows = @rows.select { |line| line.match /^\s*\d{4}\.(1|2)\s*\d*/ }

      grades_rows.each do |row|
        result = parse_row_result(row)

        @course_results << result if result
      end
    end

    def parse_progress
      total = @rows.find { |line| line.include?('Exigido') }.split(' ')
      completed = @rows.find { |line| line.include?('Integralizad') }.split(' ')

      # "Básicas Profissionais" + "Complementares obrigatórias"
      @course_results.progress.compulsory
          .set(completed[1].to_i + completed[10].to_i, total[1].to_i + total[10].to_i)
      @course_results.progress.optional
          .set(completed[4].to_i, total[4].to_i)
      @course_results.progress.flexible
          .set(completed[7].to_i, total[7].to_i)
      @course_results.progress.total
          .set(completed[13].to_i, total[13].to_i)
    end

    def parse_row_result(row)
      # Regular expression
      regex = /(\d{4}\.(?:1|2))\s*(\w*)\s*(.*?)(?=\d\d)(\d*)\s*(\d*)\s*((?:--)|(?:\d*))\s*((?:\d{1,2}\.\d{1,2})|(?:--))\s*(.*)/

      # Perform match
      semester, course_code, course_name, workload, credits,
          group, grade, situation = row.match(regex).captures

      # Process data
      course_name.strip!
      workload = workload.to_i
      credits = credits.to_i

      # Create object and return
      SigaaParser::CourseResult.new(course_code, course_name,
                                    semester, workload, credits, group, grade, situation)
    end

    # @raise [InvalidFileExtension]
    def verify_file_extension
      extension = File.extname(@file.path)

      if extension.downcase != VALID_EXTENSION
        raise InvalidFileExtension, "Invalid file extension: #{extension}. Expecting .pdf"
      end
    end

    # @raise [InvalidFileFormat]
    def verify_file_format
      last_line = @rows.find { |row| row.include?('Para verificar a autenticidade') }

      if last_line.nil?
        raise InvalidFileFormat, 'This file does not look like a Transcript of Records'
      end
    end

    # Opens the @file with the PDF reader tool and stores rows in @rows
    def convert_to_rows
      pdf = PDF::Reader.new(@file)
      @rows = []

      pdf.pages.each do |page|
        @rows += page.text.split("\n")
      end
    end
  end
end
