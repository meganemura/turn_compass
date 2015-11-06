require 'forwardable'

module TurnCompass
  class Player
    extend Forwardable

    attr_reader   :instance
    attr_accessor :track, :position

    def initialize(player_object = Tunees::Application)
      @player = player_object
    end

    # FIXME: prevent updating illegal position
    def_delegator :@player, :player_position,  :position
    def_delegator :@player, :player_position=, :position=
  end
end
