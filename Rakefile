$LOAD_PATH << "#{ENV['HOME']}/Projects/pith/lib"

require "pith/console_logger"
require "pith/project"
require "pith/watcher"

def project
  @project ||= Pith::Project.new(:input_dir => "src", :output_dir => "out", :logger => Pith::ConsoleLogger.new)
end

task "default" => "build"

task "build" do
  project.build
end

task "watch" do
  Pith::Watcher.new(project).call
end

desc "Publish to dogbiscuit.org"
task "push" do
  sh "rsync -av out/ dogbiscuit:dogbiscuit.org/"
end
