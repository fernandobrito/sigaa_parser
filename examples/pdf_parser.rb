require_relative '../lib/sigaa_parser'

parser = SigaaParser::TranscriptParser.new(File.new('../spec/transcripts/11118303.pdf'))

puts parser.course_results.student

puts 'Normal:'
parser.course_results.semesters.each do |semester|
  puts "#{semester}: #{parser.course_results.average_up_to(semester)}"
end

puts parser.course_results.results.sort_by(&:semester)
