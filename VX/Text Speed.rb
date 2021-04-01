=begin
===============================================================================
 Text Speed
 Change text speed by Zero_G v1.0
 Version: RGSS2
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
 v1.1 Change methods overwrite to alias
 v1.0 Initial
--------------------------------------------------------------------------------
=end
module ZERO
  # Speed of text, values 0 and 1 for default speed
  # 2 for double speed, 3 triple speed, ...
  TEXT_SPEED = 2
  
  # For slowing text add a delay between characters
  # 10 for very slow text, 5 slow text, 1 a bit slow
  # 0 to disable
  SLOW_TEXT = 0
	
  # Display text instantly, will ignore text speed
  # Set to false for default, true for instant text
  INSTANT_SPEED = false
end

class Window_Message < Window_Selectable
  # Alias
  alias zero_textspeed_update update
  def update
    unless @opening or @closing
      if @text != nil
        for i in 2..ZERO::TEXT_SPEED # Speed up text
          update_message
        end
      end
    end
    zero_textspeed_update
  end
  
  # Instant speed
  # Alias
  if ZERO::INSTANT_SPEED
    alias zero_update_show_fast update_show_fast
    def update_show_fast
      zero_update_show_fast
      @show_fast = true
    end
  end
  
  # Alias
  alias zero_update_message update_message
  def update_message
    @wait_count = ZERO::SLOW_TEXT # Slow text
    unless @text.nil?
      zero_update_message
    end
  end
end