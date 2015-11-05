require 'tunees'
require 'turn_compass/browser'

module TurnCompass
  def self.run
    Controller.new.run
  end

  class Controller
    def initialize
      update_position
    end

    def run
      loop do
        previous_position = update_position

        case @scroll_position <=> previous_position
        when -1
          position = Tunees::Application.player_position
          Tunees::Application.player_position = position - 3
        when 0
        when 1
          position = Tunees::Application.player_position
          Tunees::Application.player_position = position + 3
        end

        sleep 0.1
      end
    end

    def update_position
      previous_position = @scroll_position
      @scroll_position = Browser::Application.exec(%q<win = app.windows[0]; tab = win.activeTab(); return app.execute(tab, {javascript: "document.body.scrollTop"})>)

      previous_position
    end
  end
end
