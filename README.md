# gccfk
## information
Small proof of concept to show how easy it is to break static compilation of binaries with gcc, and also execution of popular statically compiled programs, such as sash. By default, gccfk also breaks execution of nasm, since nasm is used to compile assembly.
## usage
gccfk can coexist with LD_PRELOAD malware to prevent detection/removal by use of statically compiled C programs. You can add your own blacklisted programs in gccfk.c @ static char blacklisted\_progs.
## installation
\# ./install.sh</br>
That's it.
## post-installation
Any shells opened subsequent to installing gccfk will be unable to run sash, nasm, and will be unable to compile C source files with the "-static" flag.
## removal
\# chattr -ia /etc/ld.so.preload && rm /etc/ld.so.preload /lib/gccfk.so
## why break static compilation?
Statically compiling programs is the opposite of dynamically compiling programs. Statically compiled programs don't load any userland libraries, which the LD_PRELOAD attack relies on, and instead just call machine and kernel specific system calls.</br>
Statically or dynamically compiled binaries don't matter when it comes to the kernel, so any system calls manipulated on a kernel level won't change regardless of binary compilation.
## how to bypass gccfk
<a href="https://docs.python.org/2/library/os.html#os.execl">Python os.exec* functions</a></br>
Any function that isn't execve will be able to do everything normally, since gccfk by default doesn't hook the other exec* functions, due to this just being a proof of concept.
