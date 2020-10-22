cd ~
echo "=====[ Getting Depot Tools ]====="	
git clone -q https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$(pwd)/depot_tools:$PATH
gclient


mkdir v8
cd v8

echo "=====[ Fetching V8 ]====="
fetch v8
echo "target_os = ['mac']" >> .gclient
cd ~/v8/v8
git checkout refs/tags/8.4.371.19
gclient sync


echo "=====[ Building V8 ]====="
python ./tools/dev/v8gen.py x64.release -vv -- '
target_os = "mac"
is_debug = false
v8_enable_i18n_support= false
v8_target_cpu = "arm64"
v8_use_snapshot = true
v8_use_external_startup_data = true
v8_static_library = true
strip_debug_info = false
symbol_level=1
'
ninja -C out.gn/x64.release -t clean
ninja -C out.gn/x64.release wee8

SCRIPT_FOLDER=$(cd "$(dirname "$0")";pwd)
node $SCRIPT_FOLDER/genBlobHeader.js "osx 64" out.gn/x64.release/snapshot_blob.bin
