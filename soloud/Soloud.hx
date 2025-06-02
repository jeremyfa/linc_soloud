package soloud;

@:keep
@:allow(soloud.Soloud)
#if !display
@:build(linc.Linc.touch())
@:build(linc.Linc.xml('soloud'))
#end
private extern class Soloud_linc { private inline static var LINC = 1; }

typedef Result = cpp.UInt32;
typedef Handle = cpp.UInt32;
typedef Time = cpp.Float64;

/**
 * Class that handles aligned allocations to support vectorized operations
 */
@:native('SoLoud::AlignedFloatBuffer*')
extern class AlignedFloatBuffer {

    /**
     * aligned pointer
     */
    var mData:cpp.Pointer<cpp.Float32>;

    /**
     * raw allocated pointer (for delete)
     */
    var mBasePtr:cpp.Pointer<cpp.UInt8>;

    /**
     * size of buffer (w/out padding)
     */
    var mFloats:cpp.Int32;

    inline static function create():AlignedFloatBuffer {
        return untyped __cpp__('new AlignedFloatBuffer()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    /**
     * Allocate and align buffer
     */
    function init(aFloats:cpp.UInt32):Result;

    /**
     * Clear data to zero.
     */
    function clear():Void;

}

/**
 * Lightweight class that handles small aligned buffer to support vectorized operations
 */
@:native('SoLoud::TinyAlignedFloatBuffer')
extern class TinyAlignedFloatBuffer {

    /**
     * aligned pointer
     */
    var mData:cpp.Pointer<cpp.Float32>;

    var mActualData:cpp.Pointer<cpp.UInt8>;

    inline static function create():TinyAlignedFloatBuffer {
        return untyped __cpp__('new TinyAlignedFloatBuffer()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

}

enum abstract SoloudErrors(cpp.UInt32) from cpp.UInt32 to cpp.UInt32 {

    /**
     * No error
     */
    var SO_NO_ERROR       = 0;

    /**
     * Some parameter is invalid
     */
    var INVALID_PARAMETER = 1;

    /**
     * File not found
     */
    var FILE_NOT_FOUND    = 2;

    /**
     * File found, but could not be loaded
     */
    var FILE_LOAD_FAILED  = 3;

    /**
     * DLL not found, or wrong DLL
     */
    var DLL_NOT_FOUND     = 4;

    /**
     * Out of memory
     */
    var OUT_OF_MEMORY     = 5;

    /**
     * Feature not implemented
     */
    var NOT_IMPLEMENTED   = 6;

    /**
     * Other error
     */
    var UNKNOWN_ERROR     = 7;

    function toString() {

        var error:SoloudErrors = this;
        return switch error {
            case SO_NO_ERROR: 'SO_NO_ERROR';
            case INVALID_PARAMETER: 'INVALID_PARAMETER';
            case FILE_NOT_FOUND: 'FILE_NOT_FOUND';
            case FILE_LOAD_FAILED: 'FILE_LOAD_FAILED';
            case DLL_NOT_FOUND: 'DLL_NOT_FOUND';
            case OUT_OF_MEMORY: 'OUT_OF_MEMORY';
            case NOT_IMPLEMENTED: 'NOT_IMPLEMENTED';
            case UNKNOWN_ERROR: 'UNKNOWN_ERROR';
            case _: '' + this;
        }

    }

}

enum abstract SoloudBackends(cpp.UInt32) from cpp.UInt32 to cpp.UInt32 {

    var AUTO = 0;
    var SDL1 = 1;
    var SDL2 = 2;
    var PORTAUDIO = 3;
    var WINMM = 4;
    var XAUDIO2 = 5;
    var WASAPI = 6;
    var ALSA = 7;
    var JACK = 8;
    var OSS = 9;
    var OPENAL = 10;
    var COREAUDIO = 11;
    var OPENSLES = 12;
    var VITA_HOMEBREW = 13;
    var MINIAUDIO = 14;
    var NOSOUND = 15;
    var NULLDRIVER = 16;
    var BACKEND_MAX = 17;

    function toString() {

        var backend:SoloudBackends = this;
        return switch backend {
            case AUTO: 'AUTO';
            case SDL1: 'SDL1';
            case SDL2: 'SDL2';
            case PORTAUDIO: 'PORTAUDIO';
            case WINMM: 'WINMM';
            case XAUDIO2: 'XAUDIO2';
            case WASAPI: 'WASAPI';
            case ALSA: 'ALSA';
            case JACK: 'JACK';
            case OSS: 'OSS';
            case OPENAL: 'OPENAL';
            case COREAUDIO: 'COREAUDIO';
            case OPENSLES: 'OPENSLES';
            case VITA_HOMEBREW: 'VITA_HOMEBREW';
            case MINIAUDIO: 'MINIAUDIO';
            case NOSOUND: 'NOSOUND';
            case NULLDRIVER: 'NULLDRIVER';
            case BACKEND_MAX: 'BACKEND_MAX';
            case _: '' + this;
        }

    }

}

enum abstract SoloudFlags(cpp.UInt32) from cpp.UInt32 to cpp.UInt32 {
    /**
     * Use round-off clipper
     */
    var CLIP_ROUNDOFF = 1;

    var ENABLE_VISUALIZATION = 2;

    var LEFT_HANDED_3D = 4;

    var NO_FPU_REGISTER_CHANGE = 8;

    function toString() {

        var result = new StringBuf();
        var count = 0;

        if (this & CLIP_ROUNDOFF == CLIP_ROUNDOFF) {
            if (count++ > 0)
                result.add(' | ');
            result.add('CLIP_ROUNDOFF');
        }

        if (this & ENABLE_VISUALIZATION == ENABLE_VISUALIZATION) {
            if (count++ > 0)
                result.add(' | ');
            result.add('ENABLE_VISUALIZATION');
        }

        if (this & LEFT_HANDED_3D == LEFT_HANDED_3D) {
            if (count++ > 0)
                result.add(' | ');
            result.add('LEFT_HANDED_3D');
        }

        if (this & NO_FPU_REGISTER_CHANGE == NO_FPU_REGISTER_CHANGE) {
            if (count++ > 0)
                result.add(' | ');
            result.add('NO_FPU_REGISTER_CHANGE');
        }

        return result.toString();

    }

}

/**
 * Soloud core class.
 */
@:keep
@:native("SoLoud::Soloud*")
@:include('linc_soloud.h')
extern class Soloud {

    private inline static var LINC = Soloud_linc.LINC;

    inline static function create():Soloud {
        return untyped __cpp__('new SoLoud::Soloud()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    @:native("::linc::soloud::createFilterFunction")
    function createFilterFunction(
        id:Int,
        creatFunc:cpp.Callable<(filterId:Int, instanceId:Int)->Void>,
        destroyFunc:cpp.Callable<(filterId:Int, instanceId:Int)->Void>,
        filterFunc:cpp.Callable<(filterId:Int, instanceId:Int, aSamples:cpp.UInt32, aBufferSize:cpp.UInt32, aChannels:cpp.UInt32, aSamplerate:cpp.Float32, time:cpp.Float64)->Void>
    ):Filter;

    @:native("::linc::soloud::destroyFilterFunction")
    function destroyFilterFunction(id:Int):Void;

    /**
     * Initialize SoLoud. Must be called before SoLoud can be used.
     */
    function init(flags:SoloudFlags = 0, backend:SoloudBackends = AUTO, samplerate:cpp.UInt32 = 0 /* AUTO */, bufferSize:cpp.UInt32 = 0 /* AUTO */, channels:cpp.UInt32 = 2):Result;

    /**
     * Deinitialize SoLoud. Must be called before shutting down.
     */
    function deinit():Void;

    /**
     * Query SoLoud version number (should equal to SOLOUD_VERSION macro)
     */
    function getVersion():cpp.UInt32;

    /**
     * Translate error number to an asciiz string
     */
    function getErrorString(aErrorCode:SoloudErrors):cpp.ConstCharStar;

    /**
     * Returns current backend ID (BACKENDS enum)
     */
    function getBackendId():SoloudBackends;

    /**
     * Returns current backend string. May be NULL.
     */
    function getBackendString():cpp.ConstCharStar;

    /**
     * Returns current backend channel count (1 mono, 2 stereo, etc)
     */
    function getBackendChannels():cpp.UInt32;

    /**
     * Returns current backend sample rate
     */
    function getBackendSamplerate():cpp.UInt32;

    /**
     * Returns current backend buffer size
     */
    function getBackendBufferSize():cpp.UInt32;

    /**
     * Set speaker position in 3d space
     */
    function setSpeakerPosition(aChannel:cpp.UInt32, aX:cpp.Float32, aY:cpp.Float32, aZ:cpp.Float32):Result;

    /**
     * Get speaker position in 3d space
     */
    function getSpeakerPosition(aChannel:cpp.UInt32, aX:cpp.Reference<cpp.Float32>, aY:cpp.Reference<cpp.Float32>, aZ:cpp.Reference<cpp.Float32>):Result;

    /**
     * Start playing a sound. Returns voice handle, which can be ignored or used to alter the playing sound's parameters. Negative volume means to use default.
     */
    inline function play(aSound:AudioSource, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0, aPaused:Bool = false, aBus:cpp.UInt32 = 0):Handle {
        return _play(AudioSource.AudioSourceRef.fromAudioSource(aSound), aVolume, aPan, aPaused, aBus);
    }
    @:native('play')
    private function _play(aSound:AudioSource.AudioSourceRef, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0, aPaused:Bool = false, aBus:cpp.UInt32 = 0):Handle;

    /**
     * Start playing a sound delayed in relation to other sounds called via this function. Negative volume means to use default.
     */
    inline function playClocked(aSoundTime:Time, aSound:AudioSource, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0, aBus:cpp.UInt32 = 0):Handle {
        return _playClocked(aSoundTime, AudioSource.AudioSourceRef.fromAudioSource(aSound), aVolume, aPan, aBus);
    }
    @:native('playClocked')
    private function _playClocked(aSoundTime:Time, aSound:AudioSource.AudioSourceRef, aVolume:cpp.Float32 = -1.0, aPan:cpp.Float32 = 0.0, aBus:cpp.UInt32 = 0):Handle;

    /**
     * Start playing a 3d audio source
     */
    inline function play3d(aSound:AudioSource, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0, aPaused:Bool = false, aBus:cpp.UInt32 = 0):Handle {
        return _play3d(AudioSource.AudioSourceRef.fromAudioSource(aSound), aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aPaused, aBus);
    }
    @:native('play3d')
    private function _play3d(aSound:AudioSource.AudioSourceRef, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0, aPaused:Bool = false, aBus:cpp.UInt32 = 0):Handle;

    /**
     * Start playing a 3d audio source, delayed in relation to other sounds called via this function.
     */
    inline function play3dClocked(aSoundTime:Time, aSound:AudioSource, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0, aBus:cpp.UInt32 = 0):Handle {
        return _play3dClocked(aSoundTime, AudioSource.AudioSourceRef.fromAudioSource(aSound), aPosX, aPosY, aPosZ, aVelX, aVelY, aVelZ, aVolume, aBus);
    }
    @:native('play3dClocked')
    private function _play3dClocked(aSoundTime:Time, aSound:AudioSource.AudioSourceRef, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelX:cpp.Float32 = 0.0, aVelY:cpp.Float32 = 0.0, aVelZ:cpp.Float32 = 0.0, aVolume:cpp.Float32 = 1.0, aBus:cpp.UInt32 = 0):Handle;

    /**
     * Start playing a sound without any panning. It will be played at full volume.
     */
    inline function playBackground(aSound:AudioSource, aVolume:cpp.Float32 = -1.0, aPaused:Bool = false, aBus:cpp.UInt32 = 0):Handle {
        return _playBackground(AudioSource.AudioSourceRef.fromAudioSource(aSound), aVolume, aPaused, aBus);
    }
    @:native('playBackground')
    private function _playBackground(aSound:AudioSource.AudioSourceRef, aVolume:cpp.Float32 = -1.0, aPaused:Bool = false, aBus:cpp.UInt32 = 0):Handle;


    /**
     * Seek the audio stream to certain point in time. Some streams can't seek backwards. Relative play speed affects time.
     */
    function seek(aVoiceHandle:Handle, aSeconds:Time):Result;

    /**
     * Stop the sound.
     */
    function stop(aVoiceHandle:Handle):Void;

    /**
     * Stop all voices.
     */
    function stopAll():Void;

    /**
     * Stop all voices that play this sound source
     */
    inline function stopAudioSource(aSound:AudioSource):Void {
        _stopAudioSource(AudioSource.AudioSourceRef.fromAudioSource(aSound));
    }
    @:native('stopAudioSource')
    private function _stopAudioSource(aSound:AudioSource.AudioSourceRef):Void;

    /**
     * Count voices that play this audio source
     */
    inline function countAudioSource(aSound:AudioSource):cpp.Int32 {
        return _countAudioSource(AudioSource.AudioSourceRef.fromAudioSource(aSound));
    }
    @:native('countAudioSource')
    private function _countAudioSource(aSound:AudioSource.AudioSourceRef):cpp.Int32;

    /**
     * Set a live filter parameter. Use 0 for the global filters.
     */
    function setFilterParameter(aVoiceHandle:Handle, aFilterId:cpp.UInt32, aAttributeId:cpp.UInt32, aValue:cpp.Float32):Void;

    /**
     * Get a live filter parameter. Use 0 for the global filters.
     */
    function getFilterParameter(aVoiceHandle:Handle, aFilterId:cpp.UInt32, aAttributeId:cpp.UInt32):cpp.Float32;

    /**
     * Fade a live filter parameter. Use 0 for the global filters.
     */
    function fadeFilterParameter(aVoiceHandle:Handle, aFilterId:cpp.UInt32, aAttributeId:cpp.UInt32, aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Oscillate a live filter parameter. Use 0 for the global filters.
     */
    function oscillateFilterParameter(aVoiceHandle:Handle, aFilterId:cpp.UInt32, aAttributeId:cpp.UInt32, aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Time):Void;


    /**
     * Get current play time, in seconds.
     */
    function getStreamTime(aVoiceHandle:Handle):Time;

    /**
     * Get current sample position, in seconds.
     */
    function getStreamPosition(aVoiceHandle:Handle):Time;

    /**
     * Get current pause state.
     */
    function getPause(aVoiceHandle:Handle):Bool;

    /**
     * Get current volume.
     */
    function getVolume(aVoiceHandle:Handle):cpp.Float32;

    /**
     * Get current overall volume (set volume * 3d volume)
     */
    function getOverallVolume(aVoiceHandle:Handle):cpp.Float32;

    /**
     * Get current pan.
     */
    function getPan(aVoiceHandle:Handle):cpp.Float32;

    /**
     * Get current sample rate.
     */
    function getSamplerate(aVoiceHandle:Handle):cpp.Float32;

    /**
     * Get current voice protection state.
     */
    function getProtectVoice(aVoiceHandle:Handle):Bool;

    /**
     * Get the current number of busy voices.
     */
    function getActiveVoiceCount():cpp.UInt32;

    /**
     * Get the current number of voices in SoLoud
     */
    function getVoiceCount():cpp.UInt32;

    /**
     * Check if the handle is still valid, or if the sound has stopped.
     */
    function isValidVoiceHandle(aVoiceHandle:Handle):Bool;

    /**
     * Get current relative play speed.
     */
    function getRelativePlaySpeed(aVoiceHandle:Handle):cpp.Float32;

    /**
     * Get current post-clip scaler value.
     */
    function getPostClipScaler():cpp.Float32;

    /**
     * Get current global volume
     */
    function getGlobalVolume():cpp.Float32;

    /**
     * Get current maximum active voice setting
     */
    function getMaxActiveVoiceCount():cpp.UInt32;

    /**
     * Query whether a voice is set to loop.
     */
    function getLooping(aVoiceHandle:Handle):Bool;

    /**
     * Get voice loop point value
     */
    function getLoopPoint(aVoiceHandle:Handle):Time;


    /**
     * Set voice loop point value
     */
    function setLoopPoint(aVoiceHandle:Handle, aLoopPoint:Time):Void;

    /**
     * Set voice's loop state
     */
    function setLooping(aVoiceHandle:Handle, aLooping:Bool):Void;

    /**
     * Set current maximum active voice setting
     */
    function setMaxActiveVoiceCount(aVoiceCount:cpp.UInt32):Result;

    /**
     * Set behavior for inaudible sounds
     */
    function setInaudibleBehavior(aVoiceHandle:Handle, aMustTick:Bool, aKill:Bool):Void;

    /**
     * Set the global volume
     */
    function setGlobalVolume(aVolume:cpp.Float32):Void;

    /**
     * Set the post clip scaler value
     */
    function setPostClipScaler(aScaler:cpp.Float32):Void;

    /**
     * Set the pause state
     */
    function setPause(aVoiceHandle:Handle, aPause:Bool):Void;

    /**
     * Pause all voices
     */
    function setPauseAll(aPause:Bool):Void;

    /**
     * Set the relative play speed
     */
    function setRelativePlaySpeed(aVoiceHandle:Handle, aSpeed:cpp.Float32):Result;

    /**
     * Set the voice protection state
     */
    function setProtectVoice(aVoiceHandle:Handle, aProtect:Bool):Void;

    /**
     * Set the sample rate
     */
    function setSamplerate(aVoiceHandle:Handle, aSamplerate:cpp.Float32):Void;

    /**
     * Set panning value; -1 is left, 0 is center, 1 is right
     */
    function setPan(aVoiceHandle:Handle, aPan:cpp.Float32):Void;

    /**
     * Set absolute left/right volumes
     */
    function setPanAbsolute(aVoiceHandle:Handle, aLVolume:cpp.Float32, aRVolume:cpp.Float32, aLBVolume:cpp.Float32 = 0, aRBVolume:cpp.Float32 = 0, aCVolume:cpp.Float32 = 0, aSVolume:cpp.Float32 = 0):Void;

    /**
     * Set overall volume
     */
    function setVolume(aVoiceHandle:Handle, aVolume:cpp.Float32):Void;

    /**
     * Set delay, in samples, before starting to play samples. Calling this on a live sound will cause glitches.
     */
    function setDelaySamples(aVoiceHandle:Handle, aSamples:cpp.UInt32):Void;


    /**
     * Set up volume fader
     */
    function fadeVolume(aVoiceHandle:Handle, aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Set up panning fader
     */
    function fadePan(aVoiceHandle:Handle, aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Set up relative play speed fader
     */
    function fadeRelativePlaySpeed(aVoiceHandle:Handle, aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Set up global volume fader
     */
    function fadeGlobalVolume(aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Schedule a stream to pause
     */
    function schedulePause(aVoiceHandle:Handle, aTime:Time):Void;

    /**
     * Schedule a stream to stop
     */
    function scheduleStop(aVoiceHandle:Handle, aTime:Time):Void;


    /**
     * Set up volume oscillator
     */
    function oscillateVolume(aVoiceHandle:Handle, aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Set up panning oscillator
     */
    function oscillatePan(aVoiceHandle:Handle, aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Set up relative play speed oscillator
     */
    function oscillateRelativePlaySpeed(aVoiceHandle:Handle, aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Time):Void;

    /**
     * Set up global volume oscillator
     */
    function oscillateGlobalVolume(aFrom:cpp.Float32, aTo:cpp.Float32, aTime:Time):Void;


    /**
     * Set global filters. Set to NULL to clear the filter.
     */
    function setGlobalFilter(aFilterId:cpp.UInt32, aFilter:Filter):Void;


    /**
     * Enable or disable visualization data gathering
     */
    function setVisualizationEnable(aEnable:Bool):Void;


    /**
     * Calculate and get 256 floats of FFT data for visualization. Visualization has to be enabled before use.
     */
    function calcFFT():cpp.Pointer<cpp.Float32>;


    /**
     * Get 256 floats of wave data for visualization. Visualization has to be enabled before use.
     */
    function getWave():cpp.Pointer<cpp.Float32>;


    /**
     * Get approximate output volume for a channel for visualization. Visualization has to be enabled before use.
     */
    function getApproximateVolume(aChannel:cpp.UInt32):cpp.Float32;


    /**
     * Get current loop count. Returns 0 if is:Handle not valid. (All audio sources may not update loop count)
     */
    function getLoopCount(aVoiceHandle:Handle):cpp.UInt32;


    /**
     * Get audiosource-specific information from a voice.
     */
    function getInfo(aVoiceHandle:Handle, aInfoKey:cpp.UInt32):cpp.Float32;


    /**
     * Create a voice group. Returns 0 if unable (out of voice groups / out of memory)
     */
    function createVoiceGroup():Handle;

    /**
     * Destroy a voice group.
     */
    function destroyVoiceGroup(aVoiceGroupHandle:Handle):Result;

    /**
     * Add a voice to:Handle a voice group
     */
    function addVoiceToGroup(aVoiceGroupHandle:Handle, aVoiceHandle:Handle):Result;

    /**
     * Is this a:Handle valid voice group?
     */
    function isVoiceGroup(aVoiceGroupHandle:Handle):Bool;

    /**
     * Is this voice group empty?
     */
    function isVoiceGroupEmpty(aVoiceGroupHandle:Handle):Bool;


    /**
     * Perform 3d audio parameter update
     */
    function update3dAudio():Void;


    /**
     * Set the speed of sound constant for doppler
     */
    function set3dSoundSpeed(aSpeed:cpp.Float32):Result;

    /**
     * Get the current speed of sound constant for doppler
     */
    function get3dSoundSpeed():cpp.Float32;

    /**
     * Set 3d listener parameters
     */
    function set3dListenerParameters(aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aAtX:cpp.Float32, aAtY:cpp.Float32, aAtZ:cpp.Float32, aUpX:cpp.Float32, aUpY:cpp.Float32, aUpZ:cpp.Float32, aVelocityX:cpp.Float32 = 0.0, aVelocityY:cpp.Float32 = 0.0, aVelocityZ:cpp.Float32 = 0.0):Void;

    /**
     * Set 3d listener position
     */
    function set3dListenerPosition(aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32):Void;

    /**
     * Set 3d listener "at" vector
     */
    function set3dListenerAt(aAtX:cpp.Float32, aAtY:cpp.Float32, aAtZ:cpp.Float32):Void;

    /**
     * set 3d listener "up" vector
     */
    function set3dListenerUp(aUpX:cpp.Float32, aUpY:cpp.Float32, aUpZ:cpp.Float32):Void;

    /**
     * Set 3d listener velocity
     */
    function set3dListenerVelocity(aVelocityX:cpp.Float32, aVelocityY:cpp.Float32, aVelocityZ:cpp.Float32):Void;


    /**
     * Set 3d audio source parameters
     */
    function set3dSourceParameters(aVoiceHandle:Handle, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32, aVelocityX:cpp.Float32 = 0.0, aVelocityY:cpp.Float32 = 0.0, aVelocityZ:cpp.Float32 = 0.0):Void;

    /**
     * Set 3d audio source position
     */
    function set3dSourcePosition(aVoiceHandle:Handle, aPosX:cpp.Float32, aPosY:cpp.Float32, aPosZ:cpp.Float32):Void;

    /**
     * Set 3d audio source velocity
     */
    function set3dSourceVelocity(aVoiceHandle:Handle, aVelocityX:cpp.Float32, aVelocityY:cpp.Float32, aVelocityZ:cpp.Float32):Void;

    /**
     * Set 3d audio source min/max distance (distance < min means max volume)
     */
    function set3dSourceMinMaxDistance(aVoiceHandle:Handle, aMinDistance:cpp.Float32, aMaxDistance:cpp.Float32):Void;

    /**
     * Set 3d audio source attenuation parameters
     */
    function set3dSourceAttenuation(aVoiceHandle:Handle, aAttenuationModel:cpp.UInt32, aAttenuationRolloffFactor:cpp.Float32):Void;

    /**
     * Set 3d audio source doppler factor to reduce or enhance doppler effect. Default = 1.0
     */
    function set3dSourceDopplerFactor(aVoiceHandle:Handle, aDopplerFactor:cpp.Float32):Void;


    /**
     * Returns mixed samples:cpp.Float32 in buffer. Called by the back-end, or user with null driver.
     */
    function mix(aBuffer:cpp.Pointer<cpp.Float32>, aSamples:cpp.UInt32):Void;

    /**
     * Returns mixed 16-bit signed integer samples in buffer. Called by the back-end, or user with null driver.
     */
    function mixSigned16(aBuffer:cpp.Pointer<cpp.UInt16>, aSamples:cpp.UInt32):Void;

}
