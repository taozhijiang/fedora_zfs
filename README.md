Fedora & ZFS

项目目的：让在Fedora下使用ZFS更贴心方便
项目缘由：ZFS是很优秀的“终极”文件系统，Fedora以强大（强势）的RedHat做后盾，一定程度上
代表了Linux的发展方向。但是由于许可证的原因，ZFS一直都没进入到内核代码的主分支，导致
Linux下使用ZFS比较的困难，甚至很多Linuxer都不知道这么优秀的文件系统。本课题就是想方便
在Fedora下安装和使用ZFS。

20150604：
创建了freesign-repo，可以在https://freesign.net/freesign-repo/下面导入证书，使用打包
的ZFS工具。
livecd-creator，创建包含ZFS的Live镜像。

TODO：
修改安装器，在安装的时候支持zfs的文件系统选项。