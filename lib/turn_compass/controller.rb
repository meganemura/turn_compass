require 'tunees'
require 'turn_compass/browser'
require 'turn_compass/player'

module TurnCompass
  class Controller
    attr_reader :player

    def initialize
      @player = Player.new
      update_position
    end

    def run
      loop do
        previous_position = update_position

        case @scroll_position <=> previous_position
        when -1
          player.position -= 3
        when 0
          # noop
        when 1
          player.position += 3
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
