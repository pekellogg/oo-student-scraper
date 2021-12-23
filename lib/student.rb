require "pry"
class Student

  attr_accessor :name, :location, :twitter, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def self.all
    @@all
  end

  def initialize(student_hash)
    student_hash.each do |key, value|
      self.send(("#{key}="), value)
    end
    @@all << self
  end

  # students_array is an array of hashes w/ 2 key/value pairs of :name, :location
  def self.create_from_collection(students_array)
    students_array.each do |student|
      Student.new(student)
    end
  end

  # attributes_hash is a hash representing a student's key/value pairs of social_type => social_url 
  def add_student_attributes(attributes_hash)
    attributes_hash.each do |social, value|
      self.send(("#{social}="), value)
    end
  end

end

