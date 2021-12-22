require_relative "../config.rb"

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
      # if string includes the first 3 chars of first name and last name, create :blog key
      name = doc.css("div.vitals-text-container h1.profile-name").text.downcase.split(" ")
      if key.match(/.*(#{name[0][0..2]}).*(#{name[1][0..2]}).*/)
        profile[:blog] = profile[key.to_sym]
        profile.delete(key.to_sym)
      end
    profile[:profile_quote] = doc.css("div.profile-quote").text if doc.css("div.profile-quote")
    profile[:bio] = doc.css("div.bio-content").children.css("div.description-holder p").text
    end
    profile
  end

end

  # xtra helper method_1 
  # def self.all_students(profiles)
  #   all_urls = []
  #   profiles.each do |student_hash|
  #     url = student_hash[:profile_url]
  #     complete_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/" + url
  #     all_urls << complete_url
  #   end
  #   all_urls
  # end

  # xtra helper method_2 
  # def self.all_socials_by_student(urls)
  #   socials_by_student = []
  #   # grab all socials and assign 
  #   urls.each do |url|
  #     doc = Nokogiri::HTML(URI.open(url))
  #     socials_container = []
  #     doc.css("div.social-icon-container a").each do |social|

  #       social.attr("href").match(/learn\.co/)
  #       social_type = social.attr("href").match(/(?<=:\/\/).*(?=.com)/).to_s
  #       social_type.delete_prefix!("www\.")
  #       social_type.delete_prefix!("uk\.") # Danny Dawson
  #       socials_container << social_type
  #     end
  #     # after grabbing all links, create student's "firstname lastname" as hash key pointing to socials_container
  #     key = doc.css("div.vitals-text-container h1.profile-name").text.to_s
  #     socials_by_student << {key.to_sym => socials_container}
  #   end
  #   socials_by_student  
  # end
