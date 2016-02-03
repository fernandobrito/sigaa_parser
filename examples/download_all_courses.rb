# Download all courses from CIÊNCIA DA COMPUTAÇÃO (162006)

require_relative '../lib/sigaa_parser'

# Authenticating
parser = SigaaParser::Parser.new
parser.authenticate!

# Getting courses
curriculum_parser = SigaaParser::CurriculumParser.new
all_courses = curriculum_parser.parse(curriculum_parser.retrieve(parser, '162006'))
puts "All courses: #{all_courses.size}"


# Mandatory courses
mandatory_courses = all_courses.select{ |course| course.semester != 0 }
puts "Mandatory courses: #{mandatory_courses.size}"


# Cache each course
course_parser = SigaaParser::CourseParser.new

parser.state_id.reset

mandatory_courses.each do |course|

  begin
    course = course_parser.parse(course_parser.retrieve(parser, course.code))
    puts "#{course}: #{course.prerequisites_for('162006').join(', ')}"
  rescue => e
    puts e
    puts e.backtrace
    parser.state_id.reset
    sleep(2)
  end
end
