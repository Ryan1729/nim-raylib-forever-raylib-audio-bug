# Nim/Raylib-Forever/raylib bug

This repo consists of small pieces of code and data from [Raylib-Forever](https://github.com/Guevara-chan/Raylib-Forever), and the [3.0.0 vesion](https://github.com/raysan5/raylib/releases/tag/3.0.0) of the [libraylib.so](https://github.com/raysan5/raylib/) that attempts to be the smallest possible reproduction of an audio playback bug.

## The Bug

I have only been able to reproduce this bug on Linux. Specifically, Ubuntu 20.04.

The expected result is that the "pew-pew" noise in the `.wav` file gets played, then the vocal from the `.ogg` file gets played.

What happens instead is, the vocal from the `.ogg` is played twice.

If we swap the order of the `LoadSound` calls, the `.wav` plays twice, suggesting the previously loaded sound is overwitten.

On Linux, the executable must be run with `LD_LIBRARY_PATH` set to a value that includes the `libraylib.so` file.
So, running the following in the same directory as the `multi_channel_reduced.nim` file should reproduce the bug:
```
LD_LIBRARY_PATH='.' nim c -r multi_channel_reduced.nim
```

