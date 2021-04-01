=begin
===============================================================================
 Dash and Walking speed plus (by Zero_G) v1.1
 Version: RGSS
===============================================================================
 == Description ==
 This script will add a dashing feature and modifying the default walking
 (and dashing speed) of the main character.

 Speed during events will follow the game engine defaults

 Speed
 -Slow: 3
 -Normal: 4
 -Fast: 5

 == Terms of Use ==
 - Free for use in non-commercial projects with credits
 - Free for use in commercial projects
 - Please provide credits to Zero_G

 == Credits ==
 -This was based on a japanese script that I couldn't find the author
  Event functionality was added by me
  
 == Changelog ==
 v1.1 - Changed update_move to Game_Player, so change of speed is only on player
   and not on NPCs

 == Usage ==
 Just add the plugin.
-------------------------------------------------------------------------------
=end

module ZERO
    MOVE_SPEED = 5
    DASH_KEY = Input::A
end

$duringEvent = false
$dashing = false

class Game_Character
    alias dash_force_move_route force_move_route
    def force_move_route(move_route)
        $duringEvent = true
        dash_force_move_route(move_route)
    end
end

class Game_Player < Game_Character
    # Override update_move
    def update_move
        # added condition
        if $duringEvent
            distance = 2 ** @move_speed
        else
            if $dashing
                distance = 2 ** (ZERO::MOVE_SPEED + 1)
            else
                distance = 2 ** ZERO::MOVE_SPEED
            end
        end
        # Rest is original code
        if @y * 128 > @real_y
            @real_y = [@real_y + distance, @y * 128].min
        end
        if @x * 128 < @real_x
            @real_x = [@real_x - distance, @x * 128].max
        end
        if @x * 128 > @real_x
            @real_x = [@real_x + distance, @x * 128].min
        end
        if @y * 128 < @real_y
            @real_y = [@real_y - distance, @y * 128].max
        end
        if @walk_anime
            @anime_count += 1.5
        elsif @step_anime
            @anime_count += 1
        end
    end
  
    # Overwrite update
    def update
    		# Add dashing
        $dashing = false
        if Input.press?(ZERO::DASH_KEY)
            $dashing = true
        end
        
        last_moving = moving?
        unless moving? or $game_system.map_interpreter.running? or
               @move_route_forcing or $game_temp.message_window_showing
          case Input.dir4
          when 2
            $duringEvent = false # Moving by input presses
            move_down
          when 4
            $duringEvent = false
            move_left
          when 6
            $duringEvent = false
            move_right
          when 8
            $duringEvent = false
            move_up
          end
        end

				# Rest is original code
        last_real_x = @real_x
        last_real_y = @real_y
        super

        if @real_y > last_real_y and @real_y - $game_map.display_y > CENTER_Y
          $game_map.scroll_down(@real_y - last_real_y)
        end

        if @real_x < last_real_x and @real_x - $game_map.display_x < CENTER_X
          $game_map.scroll_left(last_real_x - @real_x)
        end

        if @real_x > last_real_x and @real_x - $game_map.display_x > CENTER_X
          $game_map.scroll_right(@real_x - last_real_x)
        end

        if @real_y < last_real_y and @real_y - $game_map.display_y < CENTER_Y
          $game_map.scroll_up(last_real_y - @real_y)
        end

        unless moving?
          if last_moving
            result = check_event_trigger_here([1,2])
            if result == false
              unless $DEBUG and Input.press?(Input::CTRL)
                if @encounter_count > 0
                  @encounter_count -= 1
                end
              end
            end
          end

          if Input.trigger?(Input::C)
            check_event_trigger_here([0])
            check_event_trigger_there([0,1,2])
          end
        end
    end
end
