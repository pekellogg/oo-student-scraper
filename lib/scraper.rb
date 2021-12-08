require "open-uri"
require "pry"
require "nokogiri"

class Scraper

  # :name, :location, :profile_url
  def self.scrape_index_page(index_url)
    
    doc = Nokogiri::HTML(URI.open(index_url))
    
    profiles = []

    doc.css("div.roster-cards-container").each do |student_card|
      student_card.css(".student-card a").each do |student|
        name = student.css(".student-name").text
        location = student.css(".student-location").text
        link = "#{student.attr("href")}"
        profiles << {name: name, location: location, profile_url: link}
      end
    end
    profiles
  end
  
  #:twitter, :linkedin, :github, :blog, :profile_quote, :bio
  def self.scrape_profile_page(profile_url)
    
  end

end

