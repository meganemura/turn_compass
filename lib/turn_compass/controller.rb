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

      # Turn Tables
      @tables = {}
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
      if browser.is_tab_moved?
        switch_sound_output
      else
        handle_scratch
        update_tables
      end
    end

    def switch_sound_output
      logger.info browser.moved_tab_index
      index = browser.current_tab_index
      if table = @tables[index]
        player.play(table[:persistent_id], table[:position])
      end
    end

    def handle_scratch
      case browser.moved_scroll_position
      when -1
        player.position -= 3
      when 0
        # noop
      when 1
        player.position += 3
      end
    end

    def update_tables
      index = browser.current_tab_index

      return unless player.track

      @tables[index] = {
        :persistent_id => player.track.track[:persistentID],
        :position      => player.position,
      }

      logger.debug(@tables)

      nil
    end

  end
end
