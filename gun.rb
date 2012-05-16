class Gun
    # A class where gun objects are instantiated
    attr_reader :cylinder_loc, :cylinder, :bullets
    def initialize(bullets = 1, cylinder_loc = 0)
        # By default, there is always one bullet inside the gun
        @bullets = bullets
        # By default, the location of the cylinder is a random location,
        # however, if there is a given number, spin the cylinder.
        if cylinder_loc == 0
            @cylinder_loc = self.spin()
        else
            @cylinder_loc = cylinder_loc
        end

        # Initialize the cylinder of the gun, with 6 empty slots
        @cylinder = [0, 0, 0, 0, 0, 0]
        # Put bullets inside the cylinder in random locations
        counter = 0 # counter variable
        while counter < bullets
            @cylinder[@cylinder_loc] = 1
            @cylinder_loc = self.spin()
            counter += 1
        end
        # Debug message
        puts "Cylinder: " + @cylinder.to_s
    end

    def spin()
        # Spins the gun's cylinder, randomizing the current location
        @cylinder_loc = rand(0..5)
    end
  
    def load(bullets = 1)
        # Loads bullets into the gun, starting from the current location.
        # Defaults to only one bullet. Multiple bullets are added sequentially
        # in order.
        while bullets > 0
            # While we still have bullets to put in the cylinder, loop
            if @cylinder[@cylinder_loc] == 1
                # There is already a bullet here, move to the next
                self.rotate()
            else
                # There's no bullet, put the bullet in it
                @cylinder[@cylinder_loc] = 1
                bullets -= 1 # decrement the number of bullets
                self.rotate() # rotate the cylinder
            end
        end
    end

    def rotate()
        # Rotates the gun's cylinder by one index. Usually done when the
        # trigger is pulled.
        if @cylinder_loc == 5
            # We are at the last location in the cylinder already
            @cylinder_loc = 0 # go back to first location
        else
            # We are elsewhere, we can just increment
            @cylinder_loc += 1
        end
    end

    def shoot()
        # Fires the gun by referring to the gun's current cylinder and whether
        # or not there is a bullet in it
        if @cylinder[@cylinder_loc] == 1
            # There's a bullet in the chamber
            # Decrement the number of bullets
            @bullets -= 1
            # Remove the bullet in the current cylinder
            @cylinder[@cylinder_loc] = 0
            # Rotate the cylinder
            self.rotate()
            return 1 # 1 means fired
        else
            # There's no bullet
            # Rotate the cylinder anyway
            self.rotate()
            return 0 # 0 means dud
        end
    end
end
