xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed :xmlns=>'http://www.w3.org/2005/Atom' do
  xml.id "http://dogbiscuit.org/mdub/weblog"
  xml.title "DogBiscuit"
  xml.author do
    xml.name "Mike Williams"
    xml.email "mdub@dogbiscuit.org"
  end
  published_pages[0..19].each do |entry|
    xml.entry do
      xml.id "http://dogbiscuit.org/#{entry.output_path.sub(/\.html$/,'')}"
      xml.title entry.title
      xml.link :rel => "alternate", :type => "text/html", :href => href(entry)
      xml.published entry.publication_date.xmlschema
      xml.content entry.render(self), :type=>"html"
    end
  end
end
