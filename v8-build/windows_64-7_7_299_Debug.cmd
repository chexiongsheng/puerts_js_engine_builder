cd %HOMEPATH%
echo =====[ Getting Depot Tools ]=====
powershell -command "Invoke-WebRequest https://storage.googleapis.com/chrome-infra/depot_tools.zip -O depot_tools.zip"
7z x depot_tools.zip -o*
set PATH=%CD%\depot_tools;%PATH%
set GYP_MSVS_VERSION=2017
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
call gclient


mkdir v8
cd v8

echo =====[ Fetching V8 ]=====
call fetch v8
cd v8
call git checkout refs/tags/7.7.299
cd test\test262\data
call git config --system core.longpaths true
call git restore *
cd ..\..\..\
call gclient sync

echo =====[ Make dynamic_crt ]=====
node %~dp0\rep.js  build\config\win\BUILD.gn

copy %GITHUB_WORKSPACE%\v8_7_7_299_Debug_Patch\code-stub-assembler.h src\codegen\

echo =====[ Building V8 ]=====
call gn gen out.gn\x64.release -args="v8_enable_i18n_support=false is_debug=false v8_static_library=true is_clang=false v8_enable_verify_heap=true dcheck_always_on=true"

call ninja -C out.gn\x64.release -t clean
call ninja -C out.gn\x64.release

node %~dp0\genBlobHeader.js "window x64" out.gn\x64.release\snapshot_blob.bin
node %~dp0\genBlobHeader.js "window x64" out.gn\x64.release\natives_blob.bin
