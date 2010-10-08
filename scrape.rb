require 'nokogiri'
require 'open-uri'

def parse(url)
  STDERR.puts "Fetching #{url}"
  return Nokogiri::HTML(open(url))
end

people = {}

html = parse("http://demeter.inf.ed.ac.uk/statusnet/index.php/")
while not html.nil? do
  # Get list of authors on this page
  html.css("span.author").each do |vcard|
    begin
    link = vcard.at_css("a")
    img = vcard.at_css("img")
    nick = vcard.at_css("span.nickname")
  
    url = link['href']
    name = link['title']
    avatar = img['src']
    avatar_name = img['alt']
    nickname = nick.inner_html
  
    if not people.include?(nickname)
      user = { 
        :url => url,
        :name => avatar_name,
        :avatar => avatar,
        :nick => nickname
        }
      people[nickname] = user
    end
    rescue
      p vcard
      raise $!
    end
  end
  
  # Get next page
  begin
    next_link = html.at_css("li.nav_next a")['href']
    html = parse(next_link)
  rescue
    html = nil
  end
end

puts people.to_yaml