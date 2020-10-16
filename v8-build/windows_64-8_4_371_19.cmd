git config --global user.name "johnche"
git config --global user.email "johnche@tencent.com"
git config --global core.autocrlf false
git config --global core.filemode false
git config --global color.ui true

cd %HOMEPATH%
echo =====[ Getting Depot Tools ]=====
powershell -command "Invoke-WebRequest https://storage.googleapis.com/chrome-infra/depot_tools.zip -O depot_tools.zip"
7z x depot_tools.zip -o*
set PATH=%CD%\depot_tools;%PATH%
set DEPOT_TOOLS_WIN_TOOLCHAIN=0
call gclient


mkdir v8
cd v8

echo =====[ Fetching V8 ]=====
call fetch v8
echo target_os = ['win'] >> .gclient
cd v8
call git checkout refs/tags/8.4.371.19
call gclient sync


echo =====[ Building V8 ]=====
call python .\tools\dev\v8gen.py x64.release
copy ..\..\v8-build\args_win64_8_4_371_19.gn .\out.gn\x64.release\args.gn

call ninja -C out.gn\x64.release -t clean
call ninja -C out.gn\x64.release v8