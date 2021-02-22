

## 数据备份与恢复



### 一个问题

数据复制和镜像的本质技术区别


镜像 当写操作发生，要等远端返回ok才算成功。这样，两边数据完全一样。



数据复制 当写操作发生，不用等远端返回ok，这样，有一小部分数据不一致。



同步复制 模似就是镜像


复制是非同步的，就是说复制的是“那个”时刻的数据，好像做了一次“全”快照，镜像是同步的，就是说任何一个时刻数据都基本是完全相同的。

复制完成后的不小心导致的数据丢失在被复制的存储上数据还是存在的，镜像则是数据完全丢失。


话说是镜像是为了保护设备失效导致的数据丢失，复制是为了保护人为操作导致的数据丢失，他们是互补的保护动作。