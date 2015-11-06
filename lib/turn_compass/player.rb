require 'forwardable'
require 'active_support/core_ext/hash/keys'

module TurnCompass
  class Player
    extend Forwardable

    attr_reader   :instance
    attr_accessor :track, :position

    def initialize(player_object = Tunees::Application)
      @player = player_object
      @track = Track.new(current_track)
    end

    def update
    end

    def_delegator :@player, :player_position,  :position
    def position=(value)
      available_position = [value, track.length].min
      available_position = [0, available_position].max

      begin
        @player.player_position = available_position
      rescue ExecJS::ProgramError => e
        puts "ERROR: #{available_position} / #{track.length}"
        puts e
      end
    end

    def_delegator :@player, :current_track

    class Track
      attr_reader :track
      def initialize(track = {})
        @track = track.symbolize_keys
      end

      def length
        @track[:duration]
      end
    end
  end
end
