module SigaaParser
  # Facade to make it easy to parse all courses and prerequisites of given
  # curricula codes.
  class ScraperFacade
    def initialize
      # Create parser
      @scraper = SigaaParser::Scraper.new

      # Create curriculum parser
      @curriculum_parser = SigaaParser::CurriculumParser.new(@scraper)

      # Create course parser
      @course_parser = SigaaParser::CourseParser.new(@scraper)
    end

    def parse_curricula(codes)
      curricula = []

      # For each code
      codes.each do |code|
        # Parse the curriculum
        curriculum = @curriculum_parser.retrieve_and_parse(code)

        # For each course in this curriculum
        curriculum.courses.each do |course|
          # Get all prerequisites, for all curricula
          course.prerequisites = @course_parser.retrieve_and_parse(course.code).prerequisites

          # Just keep the prerequisites for this curriculum
          course.prerequisites.keep_if { |p| p.curriculum == curriculum.code }
        end

        # Add on array
        curricula << curriculum
      end

      # Return array
      curricula
    end
  end
end
