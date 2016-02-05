require 'watir-webdriver'

require 'pry'
require 'dotenv'
require 'pp'

require 'active_support/core_ext/array'

Dotenv.load

# Helpers
require_relative 'helpers/string_helpers'
require_relative 'helpers/try_rescue'

# Modules
require_relative 'sigaa_parser/cacheable'
require_relative 'sigaa_parser/menu_navigator'

# Classes
require_relative 'sigaa_parser/version'
require_relative 'sigaa_parser/scraper'
require_relative 'sigaa_parser/curriculum_parser'
require_relative 'sigaa_parser/course_parser'

# Models
require_relative 'sigaa_parser/models/course'
require_relative 'sigaa_parser/models/student'
require_relative 'sigaa_parser/models/prerequisites'
require_relative 'sigaa_parser/models/curriculum'

module SigaaParser ; end
