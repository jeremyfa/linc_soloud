//hxcpp include should be first
#include <hxcpp.h>
#include "./linc_soloud.h"

#include <mutex>
#include <unordered_map>

namespace linc {

    namespace soloud {

        FunctionFilterInstance::FunctionFilterInstance(int filterId, int instanceId, SoloudFilterFunction filterFunc, SoloudDestroyFilterInstanceFunction destroyFunc) {
            mFilterId = filterId;
            mInstanceId = instanceId;
            mFilterFunc = filterFunc;
            mDestroyFunc = destroyFunc;
        }

        FunctionFilterInstance::~FunctionFilterInstance() {
            int haxe_stack_ = 99;
            hx::SetTopOfStack(&haxe_stack_, true);
            mDestroyFunc(mFilterId, mInstanceId);
            hx::SetTopOfStack((int *)0, true);
        }

        void FunctionFilterInstance::filter(float *aBuffer, unsigned int aSamples, unsigned int aChannels, float aSamplerate, double aTime) {
            int haxe_stack_ = 99;
            hx::SetTopOfStack(&haxe_stack_, true);
            mFilterFunc(mFilterId, mInstanceId, aBuffer, aSamples, aChannels, aSamplerate, aTime);
            hx::SetTopOfStack((int *)0, true);
        }

        SoLoud::FilterInstance* FunctionFilter::createInstance() {
            int instanceId = mNextInstanceId.fetch_add(1);
            int haxe_stack_ = 99;
            hx::SetTopOfStack(&haxe_stack_, true);
            mCreateFunc(mId, instanceId);
            hx::SetTopOfStack((int *)0, true);
            return new FunctionFilterInstance(mId, instanceId, mFilterFunc, mDestroyFunc);
        }

        FunctionFilter::FunctionFilter(int id, SoloudCreateFilterInstanceFunction createFunc, SoloudDestroyFilterInstanceFunction destroyFunc, SoloudFilterFunction filterFunc) : mNextInstanceId(1) {
            mId = id;
            mCreateFunc = createFunc;
            mDestroyFunc = destroyFunc;
            mFilterFunc = filterFunc;
        }

        std::unordered_map<int, FunctionFilter*> functionFilters;
        std::mutex functionFiltersMutex;

        SoLoud::Filter* createFilterFunction(int id, SoloudCreateFilterInstanceFunction createFunc, SoloudDestroyFilterInstanceFunction destroyFunc, SoloudFilterFunction filterFunc) {
            std::lock_guard<std::mutex> lock(functionFiltersMutex);
            FunctionFilter* filter = new FunctionFilter(id, createFunc, destroyFunc, filterFunc);
            functionFilters[id] = filter;
            return filter;
        }

        void destroyFilterFunction(int id) {
            std::lock_guard<std::mutex> lock(functionFiltersMutex);
            auto it = functionFilters.find(id);
            if (it != functionFilters.end()) {
                delete it->second;
                functionFilters.erase(it);
            }
        }

    }
}
