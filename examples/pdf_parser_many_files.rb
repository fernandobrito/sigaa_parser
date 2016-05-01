require_relative '../lib/sigaa_parser'

Dir.glob('/tmp/transcripts/*.pdf') do |file|
  parser = SigaaParser::TranscriptParser.new(File.new(file))
  student = parser.course_results.student

  puts "#{student.name} - #{student.program}"
end