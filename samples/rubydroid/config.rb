# Debug mode flag

$debug_mode=false
#$debug_mode=true # Show fps information

# Sound mode flag

$sound_enabled=false # no sound
#$sound_enabled=:aplay # Use Linux aplay command to play sound files
#$sound_enabled=:SDL # Use SDL to play sound files

# Music flag
# Rubygame does not support music, but can be patched to include music playback.
$music_enabled=false
#$music_enabled=true # only if the music patch is used


# Theme selection 

$datapath="themes/modern/"   # hires robot pictures
#$datapath="themes/c64/"      # C64 original graphics

# Flags to use when creating surfaces
# Any combination of SWSURFACE, HWSURFACE, SRCCOLORKEY 
# See the Rubygame:Surface.new documentation for more information

$SURFACE_FLAGS=nil # default (SWSURFACE)
#$SURFACE_FLAGS=Rubygame::HWSURFACE # Put surface in graphic card memory if possible

# Screen size scaling
$scale=1.0
#$scale=2

