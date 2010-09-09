task "watch" do
  sh "pith -i src -o out watch"
end

desc "Publish to dogbiscuit.org"
task "push" do
  sh "rsync -av out/ dogbiscuit:dogbiscuit.org/"
end
