cd ~
echo "=====[ Getting Depot Tools ]====="	
git clone -q https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$(pwd)/depot_tools:$PATH
gclient


mkdir v8
cd v8

echo "=====[ Fetching V8 ]====="
fetch v8
echo "target_os = ['ios']" >> .gclient
cd ~/v8/v8
git checkout refs/tags/8.4.371.19
gclient sync


echo "=====[ Building V8 ]====="
python ./tools/dev/v8gen.py x64.release -vv -- '
target_os = "ios"
enable_ios_bitcode = true
ios_deployment_target = 10
is_component_build = false
is_debug = false
use_custom_libcxx = false 
use_xcode_clang = true
v8_enable_i18n_support = false 
v8_monolithic = true
v8_use_external_startup_data = false
'
ninja -C out.gn/x64.release -t clean
ninja -C out.gn/x64.release wee8