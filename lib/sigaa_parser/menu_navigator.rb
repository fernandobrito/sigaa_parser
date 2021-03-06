module SigaaParser
  # Mixin to add menu interaction support
  module MenuNavigator
    def page_has_menu?
      browser.div(id: 'menu-dropdown').exist?
    end

    def go_to_main_page
      browser.visit('https://sigaa.ufpb.br/sigaa/portais/discente/discente.jsf')
    end
  end
end
