require "builder/xmlmarkup"
require "time"
require "wikiwah/tilt_integration" # for legacy blog-entries in "WikiWah" format

class Pith::Input::Template 
  
  def published_at
    parse_date(meta["published"])
  end

  def updated_at
    parse_date(meta["updated"]) || published_at
  end

  private
  
  def parse_date(date_string)
    Time.parse(date_string) if date_string
  end
  
end

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
    project.inputs.select do |input|
      input.path.within?(dir_path)
    end.select do |input|
      input.respond_to?(:published_at) && !input.published_at.nil?
    end.compact.sort_by do |input|
      input.published_at
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
