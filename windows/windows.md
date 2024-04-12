## 运行windows exe程序报找不到dll
一定是exe或者其引用的某个dll找不到对应的库，使用dumpbin.exe查看依赖库。

## dumpbin.exe
* 查看依赖项
dumpbin.exe /dependents xxx.exe/xxx.dll

