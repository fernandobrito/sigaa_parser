require 'watir-webdriver'
require 'nokogiri'
require 'interface'

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
require_relative 'sigaa_parser/transcript_parser'

# Browser
require_relative 'sigaa_parser/browser/browser_adapter'
require_relative 'sigaa_parser/browser/watir_adapter'

# Models
require_relative 'sigaa_parser/models/course'
require_relative 'sigaa_parser/models/student'
require_relative 'sigaa_parser/models/prerequisites'
require_relative 'sigaa_parser/models/curriculum'
require_relative 'sigaa_parser/models/course_result'
require_relative 'sigaa_parser/models/course_results'
require_relative 'sigaa_parser/models/course_results/progress'
require_relative 'sigaa_parser/models/course_results/average_calculator_template'

module SigaaParser ; end
