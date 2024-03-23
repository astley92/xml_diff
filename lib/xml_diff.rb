# frozen_string_literal: true

require("zeitwerk")
loader = Zeitwerk::Loader.for_gem
loader.setup

module XmlDiff
  VERSION = "0.1.0"
end
