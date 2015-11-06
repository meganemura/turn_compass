require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/string/strip'

module TurnCompass
  class Browser

    attr_accessor :current_tab_index
    attr_accessor :previous_tab_index

    attr_accessor :current_scroll_position
    attr_accessor :previous_scroll_position

    # Currently support only Google Chrome
    def initialize
    end

    # TODO: Integrate to one query to browser
    #         to better performance.
    def update
      # TODO: Tab
      @previous_tab_index = @current_tab_index
      @current_tab_index = get_current_tab_index

      # TODO: Tab location

      # Scroll position
      @previous_scroll_position = @current_scroll_position
      @current_scroll_position = get_scroll_position

      nil
    end

    def moved_tab_index
      current_tab_index <=> previous_tab_index
    end

    def get_current_tab_index
      begin
        Application.exec(<<-JXA.strip_heredoc)
          win = app.windows[0];
          return win.activeTabIndex();
        JXA
      rescue ExecJS::ProgramError => e
        puts e
        0
      end
    end

    def moved_scroll_position
      current_scroll_position <=> previous_scroll_position
    end

    def get_scroll_position
      begin
        Application.exec(<<-JXA.strip_heredoc)
          win = app.windows[0];
          tab = win.activeTab();
          return app.execute(tab, {javascript: "document.body.scrollTop"})
        JXA
      rescue ExecJS::ProgramError => e
        puts e
        0
      end
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
