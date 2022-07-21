package soloud;

@:keep
@:native("SoLoud::Wav*")
@:include('linc_soloud.h')
extern class Wav extends AudioSource {

    var mData:cpp.Pointer<cpp.Float32>;

    var mSampleCount:cpp.UInt32;

    inline static function create():Wav {
        return untyped __cpp__('new SoLoud::Wav()');
    }

    inline function destroy():Void {
        untyped __cpp__('delete {0}', this);
    }

    function load(aFilename:cpp.ConstCharStar):Soloud.Result;

    function loadMem(aMem:cpp.RawPointer<cpp.UInt8>, aLength:cpp.UInt32, aCopy:Bool = false, aTakeOwnership:Bool = true):Soloud.Result;

    function loadRawWave8(aMem:cpp.RawPointer<cpp.UInt8>, aLength:cpp.UInt32, aSamplerate:cpp.Float32 = 44100.0, aChannels:cpp.UInt32 = 1):Soloud.Result;

    function loadRawWave16(aMem:cpp.RawPointer<cpp.UInt16>, aLength:cpp.UInt32, aSamplerate:cpp.Float32 = 44100.0, aChannels:cpp.UInt32 = 1):Soloud.Result;

    function loadRawWave(aMem:cpp.RawPointer<cpp.Float32>, aLength:cpp.UInt32, aSamplerate:cpp.Float32 = 44100.0, aChannels:cpp.UInt32 = 1, aCopy:Bool = false, aTakeOwnership:Bool = true):Soloud.Result;

    function getLength():Soloud.Time;

}
