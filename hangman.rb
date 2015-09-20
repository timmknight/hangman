require "yaml"

class Hangman
	attr_accessor :name, :wrong_guesses, :word, :guess_arr, :wrong
	def initialize(name)
		@name = name
		@wrong_guesses = 0
		@word = random_word
		@guess_arr = start_display
		@wrong = []
		puts "Welcome to Hangman #{@name}"
		puts "You have 6 turns to save the man from hanging. Good luck!"
	end


	def display_word
		@guess_arr.each { |x| print x + " "}
		print "\nWrong guesses: "
		@wrong.each { |x| print x + " "} 
		print "\nYou have #{6 - @wrong.length} wrong guesses left.\n"
	end


	def start_display
		if @wrong_guesses != 6
			ary = Array.new(@word.length, "_")
		end
	end

	def split
		@word.split('')
	end

	def add_guess(guess)
		guess = guess.chomp
		ans = split
		correct_indexes = []
		ans.each_with_index do |x, index|
			if x.ord == guess.ord
				@guess_arr[index] = x
			end
		end

		if !@guess_arr.include?(guess) 
			if !@wrong.include?(guess)
				@wrong << guess
				@wrong_guesses += 1
			else
				puts "\nYou've already guessed that letter!"
			end
		end
	end

	def game_over?
		return true if winner?
		return true if loser?
		return false
	end

	private
		def random_word
			dict = dictionary
			num = rand(0..dict.size)
			return dict[num].upcase
		end

		def winner?
			if @word == @guess_arr.join()
				puts "#{@name} wins!"
				return true 
			end
			false
		end

		def loser?
			if @wrong_guesses == 6
				puts "#{@name} lost!"
				return true 
			end
			false
		end

		def dictionary
			strings = File.open("5desk.txt", "r")
			words = []
			strings.each do |word|
				word = word.chomp.to_s
				if word.length < 5
					words << word
				end
			end
			return words
		end
end 

class Game
	def start
		hangman = load_or_newgame
		while true
			guess = get_guess
			break if !turn(guess, hangman)
		end
	end

	def turn(guess, game)
		if validate_guess(guess)
			game.add_guess(guess)
			game.display_word
			if game.game_over? || save_or_continue(game)  
				return false
			end
		end
		return	true
	end

	def gameover_or_continue(game)
		game.game_over?
	end

	def load_or_newgame
			puts "Would you like to load a game? (Y/N)"
			str = gets.chomp
		if validate_yes(str)
			hangman = load_game?
			hangman.display_word
			return hangman
		elsif validate_no(str) 
			hangman = Hangman.new(get_name)
		else
			start
		end
	end

	def save_or_continue(data)
		puts "Save game and quit? (y/yes/n/no)"
		str = gets.chomp.upcase
		if validate_yes(str)
			save_game(data)
			return false
		end		
	end

	def validate_no(str)
		if /(^n$|^no$)/i.match(str) 
			return true
		end
		false
	end

	def validate_yes(str)
		if /(^y$|^yes$)/i.match(str) 
			return true
		end
		false
	end

	def load_game?
		YAML.load_file('game.yaml')
	end

	def validate_save
		str = gets.chomp.upcase
		puts "str = #{str}"
		validate_yes_no(str)
	end

	def save_game(data)
		File.open("game.yaml", 'w' ) do |file|
			file.write(YAML::dump(data))
		end
		return true
	end

	def get_guess
		puts "Please enter your guess"
		return gets.upcase
	end

	def validate_guess(guess)
		return false if guess.chomp.length > 1 || guess.chomp == 0
		return true if /^[A-Z]$/i.match(guess)
		false
	end

	def get_name
		puts "Please enter your name to start the game"
		return gets
	end

end

hangman = Game.new
hangman.start


