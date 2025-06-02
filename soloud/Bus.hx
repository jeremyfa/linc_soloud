package soloud;

import soloud.Soloud;

/**
 * Base class for busses
 */
@:native("SoLoud::Bus*")
@:include('linc_soloud.h')
extern class Bus {

    inline static function create():Bus {
        return untyped __cpp__('new SoLoud::Bus()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    /**
     * Set filter. Set to NULL to clear the filter.
     */
    function setFilter(aFilterId:cpp.UInt32, aFilter:Filter):Void;

    /**
     * Play sound through the bus
     */
    inline function play(aSound:AudioSource, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0, aPaused:Bool = false):Handle {
        return _play(AudioSource.AudioSourceRef.fromAudioSource(aSound), aVolume, aPan, aPaused);
    }
    @:native('play')
    private function _play(aSound:AudioSource.AudioSourceRef, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0, aPaused:Bool = false):Handle;

    /**
     * Play sound through the bus, delayed in relation to other sounds called via this function.
     */
    inline function playClocked(aSoundTime:Time, aSound:AudioSource, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0):Handle {
        return _playClocked(aSoundTime, AudioSource.AudioSourceRef.fromAudioSource(aSound), aVolume, aPan);
    }
    @:native('playClocked')
    private function _playClocked(aSoundTime:Time, aSound:AudioSource.AudioSourceRef, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0):Handle;

    /**
     * Start playing a 3d audio source through the bus
     */
    inline function play3d(aSound:AudioSource, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0, aPaused:Bool = false):Handle {
        return _play3d(AudioSource.AudioSourceRef.fromAudioSource(aSound), aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aPaused);
    }
    @:native('play3d')
    private function _play3d(aSound:AudioSource.AudioSourceRef, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0, aPaused:Bool = false):Handle;

    /**
     * Start playing a 3d audio source through the bus, delayed in relation to other sounds called via this function.
     */
    inline function play3dClocked(aSoundTime:Time, aSound:AudioSource, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0):Handle {
        return _play3dClocked(aSoundTime, AudioSource.AudioSourceRef.fromAudioSource(aSound), aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume);
    }
    @:native('play3dClocked')
    private function _play3dClocked(aSoundTime:Time, aSound:AudioSource.AudioSourceRef, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0):Handle;

    /**
     * Set number of channels for the bus (default 2)
     */
    function setChannels(aChannels:cpp.UInt32):Result;

    /**
     * Enable or disable visualization data gathering
     */
    function setVisualizationEnable(aEnable:Bool):Void;

    /**
     * Move a live sound to this bus
     */
    function annexSound(aVoiceHandle:Handle):Void;

    /**
     * Calculate and get 256 floats of FFT data for visualization. Visualization has to be enabled before use.
     */
    function calcFFT():cpp.Pointer<cpp.Float32>;

    /**
     * Get 256 floats of wave data for visualization. Visualization has to be enabled before use.
     */
    function getWave():cpp.Pointer<cpp.Float32>;

    /**
     * Get approximate volume for output channel for visualization. Visualization has to be enabled before use.
     */
    function getApproximateVolume(aChannel:cpp.UInt32):cpp.Float32;

    /**
     * Get number of immediate child voices to this bus
     */
    function getActiveVoiceCount():cpp.UInt32;

    /**
     * Get current the resampler for this bus
     */
    function getResampler():cpp.UInt32;

    /**
     * Set the resampler for this bus
     */
    function setResampler(aResampler:cpp.UInt32):Void;

    /**
     * This is equivalent of calling soloud.stopAudioSource() with the sound source
     */
    function stop():Void;

}