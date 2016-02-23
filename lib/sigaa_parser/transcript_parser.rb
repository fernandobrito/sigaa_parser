module SigaaParser

  # Parses a PDF file generated from SIGAA with the Transcript of Records
  #  of a given student.
  # Usage: Initialize an instance passing the file to the constructor. File
  #  is automatically parsed and data is accessed via attributes.
  class TranscriptParser
    class InvalidFileExtension < Exception ; end
    class InvalidFileFormat < Exception ; end
    class ParsingError < Exception ; end

    # @!attribute [r] courses
    attr_reader :courses

    # @raise [InvalidFileExtension] file is not .pdf
    # @raise [InvalidFileFormat] file is not a transcript of records from SIGAA
    # @raise [ParsingError]
    def initialize(file)
      @file = file
      @courses = []

      verify_file_extension
      verify_file_format

      parse
    end

  protected
    def parse
      # do something with @file
    end

    # @raise [InvalidFileExtension]
    def verify_file_extension

    end

    # @raise [InvalidFileFormat]
    def verify_file_format

    end
  end
end