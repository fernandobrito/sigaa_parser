# An adapter to the Watir browser driver
class WatirAdapter
  def initialize(object)
    @watir = object
  end

  def visit(url)
    @watir.goto(url)
  end

  def source_code
    @watir.html
  end

  def text_field(params)
    @watir.text_field(params)
  end

  def div(params)
    @watir.div(params)
  end

  def span(params)
    @watir.span(params)
  end

  def images(params)
    @watir.images(params)
  end

  def labels(params)
    @watir.labels(params)
  end

  def td(params)
    @watir.td(params)
  end

  def select_list(params)
    @watir.select_list(params)
  end

  def button(params)
    @watir.button(params)
  end

  implements SigaaParser::BrowserAdapter
end
