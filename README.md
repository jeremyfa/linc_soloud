# linc_soloud

[Soloud](https://sol.gfxile.net/soloud/) bindings for Haxe C++ target

Currently tested with [linc_sdl](https://github.com/ceramic-engine/linc_sdl), but could be configured to work with other backends.

```haxe
// Declare some variables
var soloud = Soloud.create(); // Engine core
var sample = Wav.create();    // One sample

// Initialize SoLoud (automatic back-end selection)
soloud.init();

sample.load("pew_pew.wav"); // Load a wave file
soloud.play(sample);        // Play it
```
