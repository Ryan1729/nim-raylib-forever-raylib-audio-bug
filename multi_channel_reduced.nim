#*******************************************************************************************
#
#   raylib [audio] example - Multichannel sound playing
#
#   This example has been created using raylib 2.6 (www.raylib.com)
#   raylib is licensed under an unmodified zlib/libpng license (View raylib.h for details)
#
#   Example contributed by Chris Camacho (@codifies) and reviewed by Ramon Santamaria (@raysan5)
#
#   Copyright (c) 2019 Chris Camacho (@codifies) and Ramon Santamaria (@raysan5)
#   /Converted in 2*20 by Guevara-chan.
#
#*******************************************************************************************

# 
#   raylib - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
# 
#   FEATURES:
#       - NO external dependencies, all required libraries included with raylib
#       - Multiplatform: Windows, Linux, FreeBSD, OpenBSD, NetBSD, DragonFly, MacOS, UWP, Android, Raspberry Pi, HTML5.
#       - Written in plain C code (C99) in PascalCase/camelCase notation
#       - Hardware accelerated with OpenGL (1.1, 2.1, 3.3 or ES2 - choose at compile)
#       - Unique OpenGL abstraction layer (usable as standalone module): [rlgl]
#       - Multiple Fonts formats supported (TTF, XNA fonts, AngelCode fonts)
#       - Outstanding texture formats support, including compressed formats (DXT, ETC, ASTC)
#       - Full 3d support for 3d Shapes, Models, Billboards, Heightmaps and more!
#       - Flexible Materials system, supporting classic maps and PBR maps
#       - Skeletal Animation support (CPU bones-based animation)
#       - Shaders support, including Model shaders and Postprocessing shaders
#       - Powerful math module for Vector, Matrix and Quaternion operations: [raymath]
#       - Audio loading and playing with streaming support (WAV, OGG, MP3, FLAC, XM, MOD)
#       - VR stereo rendering with configurable HMD device parameters
#       - Bindings to multiple programming languages available!
# 
#   NOTES:
#       One custom font is loaded by default when InitWindow() [core]
#       If using OpenGL 3.3 or ES2, one default shader is loaded automatically (internally defined) [rlgl]
#       If using OpenGL 3.3 or ES2, several vertex buffers (VAO/VBO) are created to manage lines-triangles-quads
# 
#   DEPENDENCIES (included):
#       [core] rglfw (github.com/glfw/glfw) for window/context management and input (only PLATFORM_DESKTOP)
#       [rlgl] glad (github.com/Dav1dde/glad) for OpenGL 3.3 extensions loading (only PLATFORM_DESKTOP)
#       [raudio] miniaudio (github.com/dr-soft/miniaudio) for audio device/context management
# 
#   OPTIONAL DEPENDENCIES (included):
#       [core] rgif (Charlie Tangora, Ramon Santamaria) for GIF recording
#       [textures] stb_image (Sean Barret) for images loading (BMP, TGA, PNG, JPEG, HDR...)
#       [textures] stb_image_write (Sean Barret) for image writting (BMP, TGA, PNG, JPG)
#       [textures] stb_image_resize (Sean Barret) for image resizing algorithms
#       [textures] stb_perlin (Sean Barret) for Perlin noise image generation
#       [text] stb_truetype (Sean Barret) for ttf fonts loading
#       [text] stb_rect_pack (Sean Barret) for rectangles packing
#       [models] par_shapes (Philip Rideout) for parametric 3d shapes generation
#       [models] tinyobj_loader_c (Syoyo Fujita) for models loading (OBJ, MTL)
#       [models] cgltf (Johannes Kuhlmann) for models loading (glTF)
#       [raudio] stb_vorbis (Sean Barret) for OGG audio loading
#       [raudio] dr_flac (David Reid) for FLAC audio file loading
#       [raudio] dr_mp3 (David Reid) for MP3 audio file loading
#       [raudio] jar_xm (Joshua Reisenauer) for XM audio module loading
#       [raudio] jar_mod (Joshua Reisenauer) for MOD audio module loading
# 
# 
#   LICENSE: zlib/libpng
# 
#   raylib is licensed under an unmodified zlib/libpng license, which is an OSI-certified,
#   BSD-like license that allows static linking with closed source software:
# 
#   Copyright (c) 2013-2020 Ramon Santamaria (@raysan5)
# 
#   This software is provided "as-is", without any express or implied warranty. In no event
#   will the authors be held liable for any damages arising from the use of this software.
# 
#   Permission is granted to anyone to use this software for any purpose, including commercial
#   applications, and to alter it and redistribute it freely, subject to the following restrictions:
# 
#     1. The origin of this software must not be misrepresented; you must not claim that you
#     wrote the original software. If you use this software in a product, an acknowledgment
#     in the product documentation would be appreciated but is not required.
# 
#     2. Altered source versions must be plainly marked as such, and must not be misrepresented
#     as being the original software.
# 
#     3. This notice may not be removed or altered from any source distribution.
# 
const LEXT* = when defined(windows):".dll"
elif defined(macosx):               ".dylib"
else:                               ".so"

{.pragma: RLAPI, cdecl, discardable, dynlib: "libraylib" & LEXT.}

type rAudioBuffer* {.bycopy.} = object
# Audio stream type
# NOTE: Useful to create custom audio streams not bound to a specific file
type AudioStream* {.bycopy.} = object
    buffer*: ptr rAudioBuffer # Pointer to internal data used by the audio system
    sampleRate*: uint32 # Frequency (samples per second)
    sampleSize*: uint32 # Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    channels*: uint32 # Number of channels (1-mono, 2-stereo)
# Sound source type
type Sound* {.bycopy.} = object
    stream*: AudioStream # Audio stream
    sampleCount*: uint32 # Total number of samples

# ------------------------------------------------------------------------------------
# Audio Loading and Playing Functions (Module: audio)
# ------------------------------------------------------------------------------------
# Audio device management functions
proc InitAudioDevice*() {.RLAPI, importc: "InitAudioDevice".} # Initialize audio device and context
# Wave/Sound loading/unloading functions
proc LoadSound*(fileName: cstring): Sound {.RLAPI, importc: "LoadSound".} # Load sound from file
# Wave/Sound management functions
proc PlaySoundMulti*(sound: Sound) {.RLAPI, importc: "PlaySoundMulti".} # Play a sound (using multichannel buffer pool)

import os

InitAudioDevice()

var
    fxWav = LoadSound("resources/sound.wav")         #  Load WAV audio file
    fxOgg = LoadSound("resources/tanatana.ogg")      #  Load OGG audio file
    frame_count = 0

while frame_count < 180:
    if frame_count == 0:
        PlaySoundMulti fxWav

    if frame_count == 60:
        PlaySoundMulti fxOgg

    os.sleep(16)
    
    frame_count = frame_count + 1
