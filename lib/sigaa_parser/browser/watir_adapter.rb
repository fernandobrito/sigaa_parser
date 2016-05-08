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

  def button(params)
    @watir.button(params)
  end
end