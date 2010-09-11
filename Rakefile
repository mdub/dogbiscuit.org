$LOAD_PATH << "."

require "dogbiscuit"

task "default" => "watch"

desc "build the site"
task "build" do
  dogbiscuit.build
end

task "watch" do
  require "pith/watcher"
  Pith::Watcher.new(dogbiscuit).call
end

desc "Publish to dogbiscuit.org"
task "push" => ["build", "upload"]

task "upload" do
  sh "rsync -av out/ dogbiscuit:dogbiscuit.org/"
end

desc "Start an IRB session, with project pre-loaded"
task "console" do
  sh("irb -I . -r dogbiscuit")
end
