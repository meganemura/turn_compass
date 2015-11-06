require 'tunees'
require 'turn_compass/browser'
require 'turn_compass/player'

module TurnCompass
  class Controller
    attr_reader :player
    attr_reader :browser

    def initialize
      @player = Player.new
      @browser = Browser.new
    end

    def run
      loop do
        update
        handle
        sleep 0.1
      end
    end

    def update
      browser.update
    end

    def handle
      case browser.moved_scroll_position
      when -1
        player.position -= 3
      when 0
        # noop
      when 1
        player.position += 3
      end
    end
  end
end
