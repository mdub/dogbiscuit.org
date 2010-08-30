require 'pathname'
require 'shellwords'
require 'yaml'

old_blog_dir = Pathname("/Users/mdub/DogBiscuit/WebSite/WebLog")
new_blog_dir = Pathname("weblog")

Pathname.glob("#{old_blog_dir}/**/*.txt").each do |old_entry|

  relative_path = old_entry.relative_path_from(old_blog_dir)
  new_entry = new_blog_dir + relative_path.to_s.sub(/\.txt/, ".html.wah")

  new_entry.parent.mkpath

  old_entry.open do |old|
    new_entry.open("w") do |out|

      headers = {}
      old.each do |line|
        if (line =~ /^$/)
          break
        end
        key, value = line.chomp.split(": ", 2)
        headers[key] = value
      end
      headers["title"] = headers.delete("Subject")
      headers["published"] = headers.delete("Date")
      
      out.puts YAML.dump(headers)
      out.puts "...\n\n"

      out.puts(old.read)
      
    end
  end
  
end
