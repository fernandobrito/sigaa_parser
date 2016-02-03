# SigaaParser

**Pet-project. Use at your own risk. Low test coverage ratio.**

Gem to scrap and parse the academic web system (SIGAA) used on my home university (UFPB).

## Features

### Authenticates with given username and password

To access data from the system, we first need to log in. 
If the student has more than one enrollment ID, the most recent one is selected.

### Parses the curricular structure of a bachelor program

Given the ID of a bachelor program, it is possible to parse all mandatory course
names that make this bachelor program, including its dependencies (prerequisites).

### Caches HTML responses

To make development faster, course and bachelor program pages are cached under
the `cache` folder.

### Keeps track of javax.faces.ViewState

SIGAA is developed using JSF. In order for our parser to work, we need to keep track
of the `javax.faces.ViewState ID`, which is an integer returned on every response. This
number must be incremented and sent back on every request.

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

## Development

## To-do

* Parse program by name (instead of ID);
* Parse grades and completed courses by student (either by login and password, or transcript PDF file).

## Contributing

