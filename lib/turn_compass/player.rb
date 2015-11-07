require 'forwardable'
require 'active_support/core_ext/hash/keys'

module TurnCompass
  class Player
    extend Forwardable

    attr_reader   :logger
    attr_reader   :instance
    attr_accessor :track, :position

    def initialize(player_object = Tunees::Application)
      @player = player_object
      setup_track_table
    end

    # In JXA, `whose` method does not work correctly.
    # We could not use tracks.whose({ persistentID: 'PERSISTENT-ID'})
    # for track specifier.
    # Alternatively, correct persistentID to ID mapping first,
    # and use tracks.byID(id) in any cases.
    # This should be changed if `whose` is fixed.
    def setup_track_table
      pid_and_id = Tunees::Application._execute(<<-JXA.strip_heredoc)
        var ret = [app.tracks.persistentID(), app.tracks.id()]
        return ret
      JXA
      @track_table = Hash[pid_and_id.transpose]
    end

    def update
      @track = begin
                 Track.new(current_track)
               rescue ExecJS::ProgramError
                 nil
               end
    end

    def play(track_persistent_id, position = 0)
      id = @track_table[track_persistent_id]
      Tunees::Application.play(id)
      self.position = position
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
    def_delegator :@player, :back_track
    def_delegator :@player, :next_track

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
