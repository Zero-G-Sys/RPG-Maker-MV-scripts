=begin
===============================================================================
 Save Menu on button press (by Zero_G)
 Version: RGSS2
===============================================================================
   ==  Description ==
 This script will open the save/load window on a button press.

 More actions for buttons can be done.
 
 == Terms of Use ==
 - Free for use in non-commercial projects with credits
 - Free for use in commercial projects
 - Please provide credits to Zero_G

 == Changelog ==
 v1.0 - Initial
 
 == Usage ==
 Just add the plugin before main.
-------------------------------------------------------------------------------
=end

module ZERO
  
  SAVE_KEY = Input::L
  LOAD = true    #Activate or deactivate load function
  LOAD_KEY = Input::F9

end

# Call scene load and scene save when button is pressed
class Scene_Map
  alias zero_update update
  def update
    zero_update
    
    if Input.trigger?(ZERO::SAVE_KEY)
      call_save
    end
    
    if Input.trigger?(ZERO::LOAD_KEY) && ZERO::LOAD
      $game_player.straighten
      $game_temp.next_scene = nil
      $scene = Scene_File.new(false, false, true)
    end
  end
end

class Scene_Battle
  alias save_battle_update update
  def update
    if Input.trigger?(ZERO::LOAD_KEY) && ZERO::LOAD
      $game_player.straighten
      $game_temp.next_scene = nil
      $scene = Scene_File.new(false, false, true)
    end
    save_battle_update
  end
end 