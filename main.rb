require_relative 'gun'

class Game
    # Main game class
    def initialize()
        # The names of the players involved:
        @player_names = []
    end

    def main_menu()
        # method that displays the main menu and accepts input from the user
        puts "Select a game mode"
        puts "[a] oneshot [b] lastman"
        puts "Your choice: "
        # wait for input from the user
        @mode = gets.chomp
    end

    def start_game()
        # method that starts the game.
        # invoke the main menu
        self.main_menu()
    end

end

if __FILE__ == $0
    game = Game.new()
    game.start_game()
end
