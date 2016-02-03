require_relative 'helpers/open_in_browser'
require_relative 'helpers/string_helpers'
require_relative 'helpers/try_rescue'

require_relative 'sigaa_parser/cacheable'

require_relative 'sigaa_parser/version'
require_relative 'sigaa_parser/parser'
require_relative 'sigaa_parser/curriculum_parser'
require_relative 'sigaa_parser/course_parser'

require_relative 'sigaa_parser/models/course'
require_relative 'sigaa_parser/models/student'
require_relative 'sigaa_parser/models/state_view_id'
require_relative 'sigaa_parser/models/prerequisites'

require 'mechanize'
require 'pry'
require 'dotenv'

require 'active_support/core_ext/array'

Dotenv.load

module SigaaParser
end
