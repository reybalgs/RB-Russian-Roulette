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

        if @mode == 'a'
            self.oneshot()
        end    
    end

    def ask_names(max_players = 2)
        # Method that asks the names of the players, loops until the max
        # number of players are met.
        #
        # By default, it assumes that the max number of players are 2, unless
        # parameters were passed.
        names = [] # an array of names
        counter = 1 # A counter variable
        while counter <= max_players
            # Loop while we haven't gone through the max number of players
            puts "Name of Player " + counter.to_s + ": "
            names << gets.chomp # append to array
            counter += 1
        end
        return names
    end

    def oneshot()
        # The oneshot gamemode, where there is only one bullet, and the winner
        # is also the loser who unfortunately gets shot
        # First we also need to create a gun
        gun = Gun.new
        num_players = 0 # variable to keep track of the number of players
        while num_players <= 1
            puts 'Please enter the number of players: '
            num_players = gets.chomp.to_i
            if num_players <= 1
                puts 'Invalid input! Please try again!'
            end
        end
        puts num_players.to_s
        # Now let's ask the names of the players
        @player_names = ask_names(num_players)
        
        shot = 0 # a variable to turns true when someone has been shot
        current_player = 0 # a variable that keeps track of the number of
                           # players

        puts shot.to_s
        while shot == 0
            # Loop while someone hasn't been shot yet
            puts @player_names[current_player] + ", it's your turn\n"
            # Spin the gun
            gun.spin()
            puts @player_names[current_player] + " spins the cylinder.\n"
            puts "Press enter to shoot.\n"

            puts @player_names[current_player] + " pulls the trigger.\n"
            gets

            shot = gun.shoot() # shoots the gun
            puts shot.to_s + "\n"
            puts gun.cylinder_loc.to_s + "\n"
            puts gun.cylinder.to_s + "\n"

            if shot == 1
                # Someone has been shot
                print "BANG!\n"
                print @player_names[current_player] + " has been shot!\n"
            else
                # Current player didn't get shot
                print "Click!"
                print @player_names[current_player] + " is still alive!\n"
                # Move on to the next player
                puts "Current Player: " + current_player.to_s + "\n"
                puts "Max Players: " + num_players.to_s + "\n"
                if current_player == num_players
                    # We are at the last player already, so go to the first one
                    # again
                    current_player = 0
                else
                    # Go to the next player
                    current_player += 1
                end
            end
            gets
        end
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
