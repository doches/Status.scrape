# Scrape the public timeline for users
# Usage: ruby #{__FILE__} url_to_public_timeline > users.yaml

require 'nokogiri'
require 'open-uri'

def parse(url)
  STDERR.puts "Fetching #{url}"
  return Nokogiri::HTML(open(url))
end

input = ARGV.shift

people = {}

html = parse(input)
pages = 0
while not html.nil? and pages < 10 do
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
  
  pages += 1
end

puts people.to_yaml
