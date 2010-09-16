require "builder/xmlmarkup"
require "wikiwah/tilt_integration" # for legacy blog-entries in "WikiWah" format

require "pith/plugins/publication"

class ::String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end

class ::Pathname
  def within?(ancestor_path)
    self.to_str.starts_with?(ancestor_path.to_str + "/")
  end
end

project.assume_content_negotiation = true
project.assume_directory_index = true

project.helpers do

  def published_pages(dir_path = current_input.path.parent)
    dir_path = Pathname(dir_path)
    project.published_inputs.select do |input|
      input.path.within?(dir_path)
    end.reverse
  end
  
  def interesting_path_components
    page.output_path.to_str.sub(%r{(/index)?\.html$}, '').split("/")
  end
  
  def breadcrumb_trail
    trail = [link("/mdub/", %{<span class="title">dogbiscuit</span>})]
    current_path = []
    interesting_path_components.each do |path_component|
      current_path << path_component
      trail << breadcrumb_link(path_component, current_path.join("/"))
    end
    trail.join("/")
  end
  
  def breadcrumb_link(name, path)
    ["/index.html", ".html", ""].each do |suffix|
      target_path = Pathname("#{path}#{suffix}")
      begin
        return link(input(target_path), name)
      rescue Pith::ReferenceError
      end
    end
    return name
  end
  
  def link_elsewhere(type, uri, label = nil)
    icon_uri = href("/images/social/#{type}_32.png")
    link = %{<a href="#{uri}"><img src="#{icon_uri}" /></a>}
    if label
      link += %{ <a href="#{uri}">#{label}</a>}
    end
    link
  end
  
end
