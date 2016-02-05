module SigaaParser
  module MenuNavigator
    def page_has_menu?
      @scraper.browser.div(id: 'menu-dropdown').exist?
    end

    def go_to_main_page
      @scraper.browser.goto('https://sigaa.ufpb.br/sigaa/portais/discente/discente.jsf')
    end
  end
end