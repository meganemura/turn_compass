require 'logger'

require 'tunees'
require 'turn_compass/browser'
require 'turn_compass/player'

module TurnCompass
  class Controller
    attr_reader :player
    attr_reader :browser
    attr_reader :logger

    def initialize
      @logger = Logger.new(STDOUT)
      @logger.level = if ENV['DEBUG'] == '1' || ENV['DEBUG'].to_s.downcase == 'true'
                        Logger::DEBUG
                      else
                        Logger::INFO
                      end

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
      logger.debug('*')
      browser.update
      player.update
    end

    def handle
      case browser.moved_tab_index
      when -1
        player.back_track
      when 0
        # noop
      when 1
        player.next_track
      end

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
