
## 查看内存情况
valgrind --tool=massif your_program

要查看某个线程占用的内存，您可以使用操作系统提供的工具或命令来获取相关信息。以下是在不同操作系统下查看线程内存占用的方法：


### 使用 top 命令：

在终端中运行 top 命令，然后按下 H 键以显示线程视图。这将显示所有线程的内存占用情况。
top
### 使用 ps 命令：

使用 ps 命令来查看特定线程的内存占用情况。例如，以下命令将显示进程 ID 为 <pid> 的线程的内存占用：

```
ps -eLo pid,lwp,pmem,pcpu,args | grep <pid>
```

### 使用 pmap 命令：
使用 pmap 命令来查看特定线程的内存映射和使用情况。以下命令将显示进程 ID 为 <pid> 的线程的内存信息：
```
pmap -x <pid>
```
### 修改core file size
1 临时修改
ulimit -c unlimited
2 永久修改
echo "* soft core unlimited" >>/etc/security/limits.conf

### 修改线程栈大小
1 临时修改
ulimit -s 102400
2 永久修改
echo "* soft stack 102400" >>/etc/security/limits.conf

