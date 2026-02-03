extends Node

@warning_ignore("unused_signal")
signal reset_level # Resets the level. (Duh.)

var run_timer:RunTimer

# Returns the time formatted as xx:xx.xx
func time_as_display(amnt:float) -> String:
	var t:float = floor(amnt * 100) / 100
	
	# Get the num of milliseconds, seconds, and minutes.
	var mili:int = (t - floor(t)) * 100
	var seco:int = int(t - (mili / 100.0)) % 60
	var minu:int = floor((t - seco) / 60)
	
	return digi(minu) + ":" + digi(seco) + "." + digi(mili)

# Returns the num as a string, in 00 format regardless of value (below 100)
func digi(num:int) -> String: return ("0" if num < 10 else "") + str(num)
