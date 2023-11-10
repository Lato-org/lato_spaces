require "lato_spaces/version"
require "lato_spaces/engine"
require "lato_spaces/config"

module LatoSpaces
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end
end
