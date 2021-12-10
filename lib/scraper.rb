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
  
  # required: :twitter, :linkedin, :github, :blog, :profile_quote, :bio
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
  end

  # helper method_1 for social link totals analyses
  # def self.all_students(profiles)
  #   all_urls = []
  #   profiles.each do |student_hash|
  #     url = student_hash[:profile_url]
  #     complete_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/" + url
  #     all_urls << complete_url
  #   end
  #   all_urls
  # end

  # helper method_2 for social link totals analyses
  # def self.all_socials_by_student(urls)
  #   doc = Nokogiri::HTML(URI.open(index_url))
  #   urls.each do |student|

  # end

end

# test data to analyze social links with totals & total social links per student
# profile_urls = Scraper.scrape_index_page("https://learn-co-curriculum.github.io/student-scraper-test-page/")
# complete_urls = Scraper.all_students(profile_urls)


