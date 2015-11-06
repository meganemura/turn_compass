require 'execjs/runtimes/jxa'
ExecJS.runtime = ExecJS::Runtimes::JXA

require "turn_compass/browser"
require "turn_compass/controller"
require "turn_compass/version"

module TurnCompass
  def self.run
    Controller.new.run
  end
end
