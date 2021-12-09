require "open-uri"
require "pry"
require "nokogiri"
require "awesome_print"
require "pry-reload"

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
    doc = Nokogiri::HTML(URI.open(profile_url))
    profile = {}
    doc.css("div.social-icon-container a").each do |detail|
      key = detail.attr("href").match(/(?<=:\/\/).*(?=.com)/).to_s
      key.delete_prefix!("www\.")
      profile[key.to_sym] = detail.attr("href")
      end
    profile[:profile_quote] = doc.css("div.profile-quote").text if doc.css("div.profile-quote")
    profile[:bio] = doc.css("div.bio-content").children.css("div.description-holder p").text
    profile
    binding.pry
  end

end

# Scraper.scrape_profile_page("https://learn-co-curriculum.github.io/student-scraper-test-page/students/joe-burgess.html")