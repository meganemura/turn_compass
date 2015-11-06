require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/strip'

module TurnCompass
  class Browser

    attr_accessor :current_scroll_position
    attr_accessor :previous_scroll_position

    # Currently support only Google Chrome
    def initialize
    end

    def update
      @previous_scroll_position = @current_scroll_position
      @current_scroll_position = get_scroll_position

      nil
    end

    def moved_scroll_position
      current_scroll_position <=> previous_scroll_position
    end

    def get_scroll_position
      Application.exec(<<-JXA.strip_heredoc)
        win = app.windows[0];
        tab = win.activeTab();
        return app.execute(tab, {javascript: "document.body.scrollTop"})
      JXA
    end

    class Application
      def self.exec(script)
        ExecJS.exec <<-JXA.strip_heredoc
          var app = Application("Chrome")
          var ret = function() {
            #{script}
          }()

          // TODO: make this recursively
          if (Array.isArray(ret)) {
            return ret.map(function(x) { return x.properties() })
          } else if (typeof ret == 'object') {
            return ret.properties()
          } else if (typeof ret == 'function') {
            return ret.properties()
          } else {
            return ret
          }
        JXA
      end
    end
  end
end
