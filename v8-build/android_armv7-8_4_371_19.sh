sudo apt-get install -y \
    pkg-config \
    git \
    subversion \
    curl \
    wget \
    build-essential \
    python \
    xz-utils \
    zip

git config --global user.name "johnche"
git config --global user.email "johnche@tencent.com"
git config --global core.autocrlf false
git config --global core.filemode false
git config --global color.ui true


cd ~
echo "=====[ Getting Depot Tools ]====="	
git clone -q https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$(pwd)/depot_tools:$PATH
gclient


mkdir v8
cd v8

echo "=====[ Fetching V8 ]====="
fetch v8
echo "target_os = ['android']" >> .gclient
cd ~/v8/v8
./build/install-build-deps-android.sh
git checkout refs/tags/8.4.371.19
gclient sync


echo "=====[ Building V8 ]====="
python ./tools/dev/v8gen.py arm.release -vv -- '
target_os = "android"
target_cpu = "arm"
is_debug = false
v8_enable_i18n_support= false
v8_target_cpu = "arm"
use_goma = false
v8_use_snapshot = true
v8_use_external_startup_data = true
v8_static_library = true
strip_absolute_paths_from_debug_symbols = false
strip_debug_info = false
symbol_level=1
use_custom_libcxx=false
use_custom_libcxx_for_host=true
'
ninja -C out.gn/arm.release -t clean
ninja -C out.gn/arm.release