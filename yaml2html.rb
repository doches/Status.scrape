# Takes a people.yaml hash and outputs an HTML list of users/profiles

if ARGV.empty?
  STDERR.puts "Usage: ruby ${__FILE__} <people.yaml>"
  exit(1)
end

# Load people hash
people = YAML.load_file(ARGV.shift)

# Prepend a glorious HTML5 header
puts <<HTM
<!DOCTYPE html> 
<html lang="en"> 
<head> 
  <meta charset="UTF-8" /> 
  <title>Status.net Users</title> 
  <link rel="stylesheet" type="text/css" media="screen" href="people.css" />
  <meta name="viewport" content="width = 800"> 
</head> 
 
<body> 
<div id="Frame">
  <ul>
HTM

people.values.sort { |a,b| a[:name].downcase.split(" ").pop <=> b[:name].downcase.split(" ").pop }.each do |person|
  puts <<HTM
    <li>
      <a href="#{person[:url]}">
        <img src="#{person[:avatar]}" alt="#{person[:name]}" />
        <span class="name">#{person[:name]}</span>
        <span class="nickname">#{person[:nick]}</span>
      </a>
    </li>
HTM
end

# End with a glorious HTML5 footer
puts <<HTM
  </ul>
</div> 
</body> 
</html>
HTM