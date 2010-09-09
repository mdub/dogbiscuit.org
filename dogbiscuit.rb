$LOAD_PATH << "#{ENV['HOME']}/Projects/pith/lib"

require "pith/console_logger"
require "pith/project"

def dogbiscuit
  @dogbiscuit ||= Pith::Project.new(:input_dir => "src", :output_dir => "out", :logger => Pith::ConsoleLogger.new)
end
