require 'rexml/document'
include REXML


if ARGV.size < 1
  puts "\e[#{31}m#{"Not enough arguments"}\e[0m"
  return -1
end

searchId=ARGV[2]||"make-everything-ok-button"
#read origin
begin
  xmlfile = File.new(ARGV[0])
  xmldoc = Document.new(xmlfile)
rescue
  puts "\e[#{31}m#{"Can get access to files"}\e[0m"
  return -1
end

def generateSelectorsForElement(element)
  return {
      name: element.name,
      id: (element.attributes["id"]||""),
      class: (element.attributes["class"]||"")
  }
end

# find origin element
element = XPath.first(xmldoc, "//[@id='#{searchId}']")
selectors = [generateSelectorsForElement(element)]
cursor = element
while cursor.parent && cursor.parent.name !=""
    cursor = cursor.parent
    selectors =  selectors.push(generateSelectorsForElement(cursor))
end

begin
  xmlfile = File.new(ARGV[1])
  xmldoc = Document.new(xmlfile)
rescue
  puts "\e[#{31}m#{"Can get access to files"}\e[0m"
  return -1
end


res = []
limit = selectors.length-2
for counter in 1..limit
  selector=selectors[counter]
  xpath_request = "//"+ selector[:name]
  if selector[:id] || selector[:class]
    xpath_request+="["
    xpath_request+=(selector[:class]||"").split(" ").map{|a| "contains(@class,'#{a}')"}.join(" or ")
    xpath_request+=(selector[:id]||"").split(" ").map{|a| "contains(@id,'#{a}')"}.join(" or ")
    xpath_request+="]"
  end
  xpath_request+="//.."

  XPath.match(xmldoc, xpath_request).each do |el|
    break  if el.class.name != "REXML::Element"
    ressons = {}
    ressons[:counter] = {val: "The Selector matches #{ (limit-counter) / (limit-1.0) *100 }%", points: 1.0 / counter}
    ressons[:name]={val: "The Name like origin", points:1} if el.name == element.name
    ressons[:text]={val: "The Text like origin", points:1} if el.text == element.text

    element.attributes.each{ |key, value|
      if el.attributes[key] == value
        ressons[key]={val: "The #{key} like origin" , points:1}
      end
    }
    sumPoints = ressons.values.reduce(0) { |sum,x| sum + x[:points] }
    if(sumPoints>=3)
      res.push({points: sumPoints , element:el, ressons:ressons })
    end
  end
end




if res && res.size>0
  res_element =  res.sort_by {|k,v| k[:points]}[-1]
  puts "\e[#{34}m#{"It element seems good"}\e[0m"
  puts res_element[:element]
  puts "\e[#{34}m#{"Becose:"}\e[0m"
  res_element[:ressons].each { |key,resson|
    puts "#{resson[:val]} => #{resson[:points]} point(s)"
  }
  selectors = []
  cursor = element
  while cursor.parent && cursor.parent.name !=""
    cursor = cursor.parent
    selectors =  selectors.push(generateSelectorsForElement(cursor))
  end
  puts "\e[#{34}m#{"Selector:"}\e[0m"
  puts selectors
else
  puts "\e[#{33}m#{"Not find any elements"}\e[0m"
end

