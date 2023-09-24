require 'rubygems'
require 'bundler/setup'

task "default" => "watch"

desc "build the site"
task "build" do
  sh "pith -i src build"
end

desc "build the site and rebuild as required"
task "watch" do
  sh "pith -i src watch"
end

desc "Publish to dogbiscuit.org"
task "push" => ["build", "upload"]

task "upload" do
  sh "rsync -av src/_out/ mdub_dogbiscuit@ssh.nyc1.nearlyfreespeech.net:"
end

desc "Start an IRB session, with project pre-loaded"
task "console" do
  sh("irb -I . -r dogbiscuit")
end

desc "build the site and rebuild as required"
task "serve" do
  sh "pith -i src serve -L -p 9877"
end

task "browse" do
  Process.fork do
    sleep 3
    sh("open http://localhost:9877/mdub/weblog/drafts")
  end
end

desc "build the site"
task "dev" => ["browse", "serve"]

require 'rake/clean'

CLEAN << "src/_out"
