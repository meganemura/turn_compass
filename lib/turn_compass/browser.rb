require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/strip'

module TurnCompass
  class Browser

    # Currently support only Google Chrome
    def initialize
    end

    def scroll_position
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
