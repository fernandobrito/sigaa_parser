# SigaaParser

**Pet-project. Use at your own risk. Low test coverage ratio.**

Gem to scrap and parse the academic web system (SIGAA) used at UFPB.

Powers the API: https://github.com/fernandobrito/ufpb_sigaa_api

## Features

### Authenticates with given username and password

To access data from the system, we first need to log in. 
If the student has more than one enrollment ID, the most recent one is selected.

### Parses the curricular structure of a bachelor program

Given the ID of a bachelor program, it is possible to parse all mandatory course
names that make this bachelor program, including its dependencies (prerequisites).

### Parsers a Transcript of Record (PDF)

Given the Transcript of Records PDF file generated from SIGAA, returns the
parsed data (courses completed and grades).

### Caches HTML responses

To make development faster, course and bachelor program pages are cached under
the `cache` folder.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sigaa_parser'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sigaa_parser

## Usage

Check the `examples` folder.

Update `.env` file with your UFPB SIGAA username and password.

## Development

To run all the tests: `$ rspec --format documentation`

## To-do

* Parse program by name (instead of ID);
* Parse grades and completed courses by student (either by login and password, or transcript PDF file);
* Add validations after every request to see if we are on right page.

## Contributing

## History

At first we tried using `Mechanize` gem to automate the HTTP requests. However, it does not support
JavaScript. As SIGAA is developed using JSF, the requests to work, we had to keep track of `javax.faces.ViewState ID`, 
which is an integer returned on every response. This number had to be sent back on every request, and sometimes
the server would simply ignore my number and reset my session.

Afterwards we tried using `capybara` with `poltergeist`, but as `capybara` is mainly designed to be
used on acceptance tests, it was hard to make use of the lib outside that context. 

Finally, we moved to `Watir` with `PhantomJS` driver. Slow, but works fine and code is much more
readable.
