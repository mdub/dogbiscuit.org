require 'rubygems'
require 'bundler/setup'

task "default" => "watch"

desc "build the site"
task "build" do
  sh "pith -i src build"
end

task "watch" do
  sh "pith -i src watch"
end

desc "Publish to dogbiscuit.org"
task "push" => ["build", "upload"]

task "upload" do
  sh "rsync -av src/_out/ dogbiscuit:dogbiscuit.org/"
end

desc "Start an IRB session, with project pre-loaded"
task "console" do
  sh("irb -I . -r dogbiscuit")
end
