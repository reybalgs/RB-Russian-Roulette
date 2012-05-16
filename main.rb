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
        puts "[a] oneshot [b] lastman [c] turbo lastman"
        puts "Your choice: "
        # wait for input from the user
        @mode = gets.chomp

        if @mode == 'a'
            self.oneshot()
        elsif @mode == 'b'
            self.lastman()
        elsif @mode == 'c'
            self.turbo_lastman()
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
        # Now let's ask the names of the players
        @player_names = ask_names(num_players)
        
        shot = 0 # a variable to turns true when someone has been shot
        current_player = 0 # a variable that keeps track of the number of
                           # players

        while shot == 0
            # Loop while someone hasn't been shot yet
            puts @player_names[current_player] + ", it's your turn\n"
            # Spin the gun
            gun.spin()
            puts @player_names[current_player] + " spins the cylinder.\n"
            puts "Press enter to shoot.\n"
            gets

            puts @player_names[current_player] + " pulls the trigger.\n"

            shot = gun.shoot() # shoots the gun

            if shot == 1
                # Someone has been shot
                puts "BANG!\n"
                puts @player_names[current_player] + " has been shot!\n"
            else
                # Current player didn't get shot
                puts "Click!"
                puts @player_names[current_player] + " is still alive!\n"
                # Move on to the next player
                if current_player == num_players - 1
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

    def lastman()
        # The gamemode wherein there would always be one bullet inside the gun,
        # and players take turn shooting themselves. The last player alive is
        # declared the winner.
        gun = Gun.new() # create a gun
        # Now we have to get the number of players who are going to play
        num_players = 0 # initialize it to 0 first
        while num_players <= 1
            puts 'Please enter the number of players'
            num_players = gets.chomp.to_i
            if num_players <= 1
                puts 'Invalid input! Try again!'
            end
        end
        # Ask the names of the players
        @player_names = ask_names(num_players)

        # Initialize current player to 0
        current_player = 0

        while num_players > 1
            # Loop while there is still more than one player
            # Get the name of the current player
            curr_player_name = @player_names[current_player]
            
            # Spin the gun
            gun.spin()

            # Tell the player that it is now their turn
            puts curr_player_name + ", it's your turn!"
            puts curr_player_name + ", please press enter to shoot yourself."
            gets

            if gun.shoot() == 1
                # The current player has been shot
                puts "BANG!"
                puts curr_player_name + " has been shot and is out of the game!"
                # Remove the player from the list of players
                @player_names.delete_at(current_player)

                # Decrease the number of players
                num_players -= 1

                # Load the gun with a bullet again
                gun.load()

                # If the player who was shot was the last player, go back to
                # the first player
                if current_player == num_players
                    current_player = 0
                end
            else
                # Player was not shot
                puts "CLICK!"
                puts curr_player_name + " is still alive!"
                if current_player == num_players - 1
                    # Last location
                    puts(curr_player_name + " passes the gun to " +
                        @player_names[0])
                else
                    # Elsewhere
                    puts(curr_player_name + " passes the gun to " +
                        @player_names[current_player + 1])
                end

                # Go to the next player
                if current_player == num_players - 1
                    # We are at the last location
                    current_player = 0
                else
                    # We are somewhere else
                    current_player += 1
                end
            end
        end
        puts @player_names[0] + " is the winner!"
        gets
    end

    def turbo_lastman()
        # Turbo lastman is a gamemode that is quite similar to lastman, however,
        # after two rounds of nobody getting shot, an additional bullet is
        # placed in the cylinder. Another one is added once there is another
        # two rounds where nobody gets shot, and so on. The winner is the last
        # person alive.
        gun = Gun.new() # create a gun
        # Ask the number of players who are going to play
        num_players = 0 # initialize to 0 to trigger the following loop
        while num_players <= 1
            puts 'Please enter the number of players'
            num_players = gets.chomp.to_i
            if num_players <= 1
                puts 'Invalid input! Try again!'
            end
        end
        # Now we have to ask the names of the players
        @player_names = ask_names(num_players)

        # Initialize the current player to the first one
        current_player = 0
        # A variable that tracks the number of rounds where nobody got shot
        # yet
        #
        # Initialized to 0 because we still don't know if the first round is
        # safe or not
        safe_rounds = 0

        # A variable that tracks the number of bullets in play in the game.
        bullets = 1

        # Variable that keeps track if someone gets shot during a round.
        # safe_rounds depends on this variable
        shot = 0

        while num_players > 1
            # We will loop the game while there is still more than one player
            # Get the name of the current player
            curr_player_name = @player_names[current_player]

            # Turbo lastman feature
            # If two safe rounds have passed, increase the constant number of
            # bullets for every round.
            if safe_rounds == 2
                bullets += 1
                # If we still haven't loaded the gun with the extra bullet yet,
                # do it now
                if gun.bullets < bullets 
                    gun.load() # this tells the gun to load only one bullet
                elsif gun.bullets == 0
                    # There are no bullets in the gun, but this shouldn't
                    # happen
                    gun.load(bullets)
                end
                # Reset the safe rounds counter
                safe_rounds = 0

                # Announce what just happened
                puts "Nobody has been shot for two rounds! Good job!"
                puts("But that just means we are going to put an additional " +
                     "bullet in the gun from now on!")
                puts("Our gun now has " + bullets.to_s + " bullets!")
                gets
            end

            # Spin the gun for randomness
            gun.spin()

            # Tell the current player that it is now their turn
            puts curr_player_name + ", it's your turn!"
            puts curr_player_name + ", please press enter to shoot yourself."
            gets

            if gun.shoot() == 1
                # The current player has been shot
                puts "BANG!"
                puts curr_player_name + " has been shot and is out of the game!"
                # Remove that player from the list of players
                @player_names.delete_at(current_player)

                # Decrease the number of players
                num_players -= 1

                # Load the gun with a bullet again
                gun.load()

                # Someone got shot, so raise that flag
                shot = 1

                # Reset the safe rounds to 0
                safe_rounds = 0

                # If the player who was shot was the last player, go back to
                # the first player
                if current_player == num_players
                    current_player = 0

                    # Reset shot to 0 because we went over the list
                    shot = 0
                end
            else
                # Player did not get shot
                puts "CLICK!"
                puts curr_player_name + " is still alive!"
                if current_player == num_players - 1
                    # Last location
                    puts(curr_player_name + " passes the gun to " +
                        @player_names[0])
                    # Go to the first player
                    current_player = 0
                    # Since we've went past the last player without someone
                    # getting shot, increment the number of safe rounds.
                    if shot == 0
                        safe_rounds += 1
                    end
                else
                    # We are elsewhere
                    puts(curr_player_name + " passes the gun to " +
                         @player_names[current_player + 1])
                    # Go to the next player
                    current_player += 1
                end
            end
        end
        puts("Congratulations, " + @player_names[0] + ", you are a winner!")
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
