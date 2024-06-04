require 'json'
require 'rainbow'

class Finder
  DATA_FOLDER_PATH = "data/"
  DATA_FILE_FORMAT = ".json"

  def self.getFile(letter)
    filePath = DATA_FOLDER_PATH + letter + DATA_FILE_FORMAT
    file = File.read(filePath)
    JSON.parse(file)
  end

  def self.findMeaning(word)
    parsedFile = getFile(word[0])
    parsedFile[word.upcase]["MEANINGS"]["1"][1]
  end

  def self.get_random_word(letter)
    getFile(letter).keys.sample
  end
end


class Game
  def self.start
    system('clear')

    @letters = ('a'..'z').to_a.sort
    @words = Hash.new

    @letters.each do |letter|
      @words.store("#{Finder.get_random_word(letter)}","PENDING")
    end

    while @words.any? { |_, status| status == "PENDING" }
      rosco
    end

    display_final_results
  end

  def self.rosco
    @active_words = @words.select {|_,status| status == "PENDING"}

    @active_words.each_key do |word|
      display_results

      puts Rainbow("Starting with the letter "+word[0]).blue
      puts Finder.findMeaning(word)
      try = gets.chomp

      evaluate_result(word,try)
    end
  end

  def self.evaluate_result(word, try)
    if try.empty?
      puts Rainbow("SKIP").blue
    elsif try.upcase == word
      puts Rainbow("YES").green
      @words[word] = "OK"
    else
      puts Rainbow(word).red
      @words[word] = "FAIL"
    end

    sleep(1)
    system('clear')
  end

  def self.display_final_results
    count_ok = @words.count{ |_,status| status == "OK"}
    count_fail = @words.count{ |_,status| status == "FAIL"}

    puts Rainbow("Correct: #{count_ok}").green
    puts Rainbow("Incorrect: #{count_fail}").red
  end

  def self.display_results
    @words.each do |word, status|
      color = case status
              when "PENDING" then :blue
              when "OK" then :green
              when "FAIL" then :red
              end
      print Rainbow("#{word[0]} ").color(color)
    end
    puts ""
  end
end

Game.start