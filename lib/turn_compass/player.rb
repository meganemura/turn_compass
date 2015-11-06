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

    # FIXME: prevent updating illegal position
    def_delegator :@player, :player_position,  :position
    def_delegator :@player, :player_position=, :position=
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
