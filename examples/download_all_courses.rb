# Download all courses from CIÊNCIA DA COMPUTAÇÃO (162006)

require_relative '../lib/sigaa_parser'

# Authenticating
parser = SigaaParser::Parser.new
student = parser.authenticate!

pp student

# Getting courses
curriculum_parser = SigaaParser::CurriculumParser.new(parser.browser)
all_courses = curriculum_parser.retrieve_and_parse('1626669')
pp all_courses.size


# Mandatory courses
mandatory_courses = all_courses.select{ |course| course.semester != 0 }
pp mandatory_courses.size

# Cache each course
course_parser = SigaaParser::CourseParser.new(parser.browser)

mandatory_courses.each do |course|
    course = course_parser.retrieve_and_parse(course.code)
    puts "#{course}: #{course.prerequisites_for('162006').join(', ')}"
end
