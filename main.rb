require 'yaml'

class Hangman 
  
  attr_accessor :secret_word, :lives, :guesses, :word_tracker
  
  def initialize
    @secret_word = secret_words.sample
    @lives= 10
    @guesses=[]
    @word_tracker=""
    @secret_word.size.times do 
      @word_tracker+="_ "
    end    
    
  end
  
  def game_menu
    puts '(1) New Game'
    puts '(2) Load Game'
    user_input=gets.chomp
    until ['1', '2'].include?(user_input)
      puts "Invalid input. Please enter 1 or 2"
      user_input = gets.chomp
    end
    
    if user_input == '2'
      load_game
      
    end
    
    start

  end

  def save_game
    puts 'Enter File name'
    file_name= gets.chomp
    Dir.mkdir('saved_games') unless Dir.exist?('saved_games')
    filename="saved_games/#{file_name}.yaml"
    File.open(filename, 'w') do |file|
      YAML.dump([] << self, file)
    end
  end
  
  def load_game
    unless Dir.exist?('saved_games')
      puts 'No saved games found. Starting new game...'
      return
    end
    
    
    
    filenames = Dir.glob('saved_games/*').map {|filename| filename.split('/')[-1].split('.')[0]}
    puts filenames
    
    loop do
      filename = gets.chomp
      
      if filenames.include?(filename)
        puts "#{filename} loaded..."
        open_file= File.open("saved_games/#{filename}.yaml", 'r')
        loaded_game = YAML.load(open_file)
        open_file.close
        puts loaded_game.inspect
        self.secret_word=loaded_game[0].secret_word
        self.lives=loaded_game[0].lives
        self.guesses=loaded_game[0].guesses
        self.word_tracker=loaded_game[0].word_tracker
        start
      
      else
        "#{filename} does not exist."
      end
    end
    
      
      


  end
  
  
  def secret_words
    words=[]
    dictionary= File.readlines('5desk.txt')
    for word in dictionary do
      word=word.downcase.strip
      if word.length >= 5 && word.length <= 12
        
        words.push(word)
      end
    end 
    return words
  end

  def start
    loop do
      if @secret_word == @word_tracker.split.join
        puts @secret_word
        puts "you guessed the word!"
        break
      end
      puts @secret_word
      puts @word_tracker
      guess_input
      
    end
    
    
  end

  def guess_input
    if @lives>0
      puts "Enter letter"
      @guess= gets.chomp.downcase
      
      if @guess=='save'
        save_game
        puts "game saved"
      end
      
      @guesses.push(@guess)
      correct= @secret_word.include?(@guess)
      
      if correct
        puts "good guess!"
        new_tracker=@word_tracker.split
        new_tracker.each_with_index do |letter,index|
          if letter="_" && @guess==@secret_word[index]
            new_tracker[index]=@guess
            @word_tracker= new_tracker.join(" ")
          end
        end
        
      else
        @lives-=1
        puts "try again! You have #{@lives} lives left"
        
      end
    end
  
  end

end


game=Hangman.new
game.game_menu


