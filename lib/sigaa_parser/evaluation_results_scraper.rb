module SigaaParser
  # Retrieve page with evaluation results
  class EvaluationResultsScraper
    include SigaaParser::Cacheable
    include SigaaParser::MenuNavigator

    def initialize(scraper = nil)
      @scraper = scraper
    end

    def cache_name(department, semester)
      "eval-result-#{department}-#{semester}"
    end

    # @return [Array] name of departments
    def retrieve_departments_available
      navigate_to_right_page

      field = browser.select_list(name: 'form:escolha_relatorio')
      field.options[1..-1].map(&:text) # First option is "--- SELECIONE ---"
    end

    # @param [String] department the full name of department (eg: 'CI - DEPARTAMENTO DE INFORMÁTICA')
    # @param [String] semester year and semester (eg: '2014.2')
    # @return [String] HTML content of the page
    def retrieve(department, semester)
      cached_name = cache_name(department, semester)
      cached = retrieve_cache_if_enabled_and_available(cached_name)
      return cached if cached

      navigate_to_right_page
      fill_and_submit_form(department, semester)

      # Store on cache
      store_cache_if_enabled(cached_name, browser.source_code)

      browser.source_code
    end

    protected

    def browser
      @scraper.browser
    end

    def navigate_to_right_page
      # Go to main page if this page has no menu
      go_to_main_page unless page_has_menu?

      # Go to the page by accessing the menu
      browser.span(text: 'Ensino').hover
      browser.td(text: 'Avaliação Institucional').hover
      browser.td(text: 'Consultar o Resultado da Avaliação').click
    end

    def fill_and_submit_form(department, semester)
      # Fill the form
      browser.select_list(name: 'form:escolha_relatorio').select department
      browser.select_list(name: 'form:anoPeriodo').select semester

      # Submit the form
      browser.button(text: 'Gerar Relatório').click
    end
  end
end
