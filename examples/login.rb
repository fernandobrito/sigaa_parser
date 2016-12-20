# Just log in

require_relative '../lib/sigaa_parser'

# Authenticating
parser = SigaaParser::Scraper.new
student = parser.authenticate!

pp student
