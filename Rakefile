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

task "serve" do
  sh "pith -i src serve"
end

desc "Publish to dogbiscuit.org"
task "push" => ["build", "upload"]

task "upload" do
  sh "rsync -av src/_out/ dogbiscuit-nfs:"
end

desc "Start an IRB session, with project pre-loaded"
task "console" do
  sh("irb -I . -r dogbiscuit")
end

task "browse" do
  sh("open http://dogbiscuit.dev")
end

desc "build the site"
task "dev" => ["browse", "watch"]
