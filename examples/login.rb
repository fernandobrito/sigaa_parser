# Just log in

require_relative '../lib/sigaa_parser'

# Authenticating
parser = SigaaParser::Parser.new
student = parser.authenticate!

pp student

