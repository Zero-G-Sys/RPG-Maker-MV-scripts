=begin
===============================================================================
 Speedup (by Zero_G)
 Version: RGSS2
===============================================================================
 == Description ==
 This script will change the game FPS (and thus the speed of the game) while 
 a button is pressed.
 
 == Terms of Use ==
 - Free for use in non-commercial projects with credits
 - Free for use in commercial projects
 - Please provide credits to Zero_G
 
 == Credits ==
 -No one

 == Usage ==
 Just add the plugin before main.
-------------------------------------------------------------------------------
=end
module ZERO
  
  SPEEDUP_KEY = Input::X
  SPEEDUP_AMOUNT = 120 # In FPS; 120 x2; can't go higher
  FRAME_RATE = Graphics.frame_rate # Default should be 60 for vx

end

class Scene_Map
  
  alias zero_update_speedup update
  def update
    zero_update_speedup
    if Input.press?(ZERO::SPEEDUP_KEY)
      Graphics.frame_rate = ZERO::SPEEDUP_AMOUNT
    else
      Graphics.frame_rate = ZERO::FRAME_RATE
    end
  end
end

# Use speedup battle plugin
class Scene_Battle
  alias speedup_battle_update update
  def update
    Graphics.frame_rate = ZERO::FRAME_RATE
    speedup_battle_update
  end
end 