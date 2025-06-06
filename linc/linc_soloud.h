#pragma once

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include "soloud.h"
#include "soloud_wav.h"
#include "soloud_wavstream.h"

#include <atomic>

namespace linc {

    namespace soloud {

        typedef ::cpp::Function < void(int filterId, int instanceId) > SoloudCreateFilterInstanceFunction;

        typedef ::cpp::Function < void(int filterId, int instanceId) > SoloudDestroyFilterInstanceFunction;

        typedef ::cpp::Function < void(int filterId, int instanceId, float *aBuffer, unsigned int aSamples, unsigned int aChannels, float aSamplerate, SoLoud::time aTime) > SoloudFilterFunction;

        class FunctionFilter;

        class FunctionFilterInstance : public SoLoud::FilterInstance
        {
            int mFilterId;
            int mInstanceId;
            SoloudFilterFunction mFilterFunc;
            SoloudDestroyFilterInstanceFunction mDestroyFunc;
        public:
            virtual void filter(float *aBuffer, unsigned int aSamples, unsigned int aChannels, float aSamplerate, SoLoud::time aTime);
            virtual ~FunctionFilterInstance();
            FunctionFilterInstance(int filterId, int instanceId, SoloudFilterFunction filterFunc, SoloudDestroyFilterInstanceFunction destroyFunc);
        };

        class FunctionFilter : public SoLoud::Filter
        {
            std::atomic<int> mNextInstanceId;
            int mId;
            SoloudCreateFilterInstanceFunction mCreateFunc;
            SoloudDestroyFilterInstanceFunction mDestroyFunc;
            SoloudFilterFunction mFilterFunc;
        public:
            virtual SoLoud::FilterInstance *createInstance();
            FunctionFilter(int id, SoloudCreateFilterInstanceFunction createFunc, SoloudDestroyFilterInstanceFunction destroyFunc, SoloudFilterFunction filterFunc);
        };

        SoLoud::Filter* createFilterFunction(int id, SoloudCreateFilterInstanceFunction createFunc, SoloudDestroyFilterInstanceFunction destroyFunc, SoloudFilterFunction filterFunc);

        void destroyFilterFunction(int id);

    }
}
