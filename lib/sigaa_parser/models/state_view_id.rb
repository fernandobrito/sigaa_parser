module SigaaParser
  class StateViewId
    def initialize(parser)
      @id = 2
      @agent = parser.agent
    end

    def get
      puts "Getting ID: #{@id}"

      @id
    end

    def get_and_increment
      @id += 1
      puts "Getting and incrementing id ID: #{@id - 1}"

      @id - 1
    end

    def reset
      page = @agent.get('https://sigaa.ufpb.br/sigaa/portais/discente/discente.jsf')
      @id = page.search('//input[@name="javax.faces.ViewState"]').first.attr('value')[/j_id(.*)/, 1].to_i

      puts "Reseting id to #{@id}"
    end
  end
end