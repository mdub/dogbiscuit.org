require "rubygems"
require "pith/console_logger"
require "pith/project"

def dogbiscuit
  @dogbiscuit ||= Pith::Project.new(:input_dir => "src", :logger => Pith::ConsoleLogger.new)
end
