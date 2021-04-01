=begin
===============================================================================
 Text Speed
 Change text speed by Zero_G v1.1
 Version: RGSS3
===============================================================================
 == Description ==
 This script will allow you to change the speed the text is displayed.
 Text can be slowed down, speed up or to displayed instantly.

 == Terms of Use ==
 - Free for use in non-commercial projects.
 - Free for use in commercial projects.
 - Please provide credits to Zero_G.

 == Credits ==
 No one.

 == Usage ==
 Just add the plugin before main.
 
 == Changelog ==
 v1.1 Fix for window message reopening after each message
--------------------------------------------------------------------------------
=end
module ZERO
	# Speed of text, values -1, 0 and 1 for default speed
	# 2 for double speed, 3 triple speed, ...
	# -2 for half speed, -3 for 1/3 speed, ...
	TEXT_SPEED = 3
	
	# Display text instantly, will ignore text speed
  # Set to false for default, true for instant text
	INSTANT_SPEED = false
end

class Window_Message < Window_Base
	# Overwrite update_fiber
	# Faster text
  def update_fiber
    if @fiber
      @fiber.resume
      for i in 2..ZERO::TEXT_SPEED
      	@fiber.resume unless @fiber.nil?
			end
    elsif $game_message.busy? && !$game_message.scroll_mode
      @fiber = Fiber.new { fiber_main }
      @fiber.resume
    else
      $game_message.visible = false
    end
  end
  
  # Overwrite fiber_main
	# Faster text
  def fiber_main
    $game_message.visible = true
    update_background
    update_placement
    loop do
      process_all_text if $game_message.has_text?
      process_input
      $game_message.clear
      @gold_window.close
      Fiber.yield
      for i in 2..ZERO::TEXT_SPEED # Balance the fiber resumes
      	Fiber.yield 
			end
      break unless text_continue?
    end
    close_and_wait
    $game_message.visible = false
    @fiber = nil
  end

  # Alias wait_for_one_character
  # Slower text
  alias zero_wait_for_one_character wait_for_one_character
  def wait_for_one_character
    zero_wait_for_one_character
    for i in ZERO::TEXT_SPEED..-2
    	Fiber.yield unless @show_fast || @line_show_fast
  	end
  end
  
  # Overwrite update_show_fast
  # Instant text
  if ZERO::INSTANT_SPEED
	  def update_show_fast
	    @show_fast = true
	  end
	end
end