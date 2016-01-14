# Download all courses from CIÊNCIA DA COMPUTAÇÃO (162006)

require File.join(File.dirname(__FILE__), '..', 'lib', 'sigaa_parser')

# Authenticating
parser = SigaaParser::Parser.new
parser.authenticate('', '')

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
  puts "=> #{course}"

  begin
    puts course_parser.parse(course_parser.retrieve(parser, course.code))
  rescue => e
    parser.state_id.reset
    sleep(2)
  end
end