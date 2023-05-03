-- #############################
-- 基础篇-索引探索_上
-- #############################

/*
索引的常见模型
索引的出现是为了提高查询效率，但是实现索引的方式却有很多种，所以这里也就引入了索引模型的概念。可以用于提高读写效率的数据结构很多，这里我先给你介绍三种常见、也比较简单的数据结构，它们分别是哈希表、有序数组、搜索树。

哈希表是一种以键 - 值（key-value）存储数据的结构，我们只要输入待查找的键即 key，就可以找到其对应的值即 Value。哈希的思路很简单，把值放在数组里，用一个哈希函数把 key 换算成一个确定的位置，然后把 value 放在数组的这个位置。不可避免地，多个 key 值经过哈希函数的换算，会出现同一个值的情况。处理这种情况的一种方法是，拉出一个链表。假设，你现在维护着一个身份证信息和姓名的表，需要根据身份证号查找对应的名字，这时对应的哈希索引的示意图如下所示：

图中，User2 和 User4 根据身份证号算出来的值都是 N，但没关系，后面还跟了一个链表。假设，这时候你要查 ID_card_n2 对应的名字是什么，处理步骤就是：首先，将 ID_card_n2 通过哈希函数算出 N；然后，按顺序遍历，找到 User2。需要注意的是，图中四个 ID_card_n 的值并不是递增的，这样做的好处是增加新的 User 时速度会很快，只需要往后追加。但缺点是，因为不是有序的，所以哈希索引做区间查询的速度是很慢的。你可以设想下，如果你现在要找身份证号在[ID_card_X, ID_card_Y]这个区间的所有用户，就必须全部扫描一遍了。
![./basis_index_A_Hash.webp](哈希表示例)
所以，哈希表这种结构适用于只有等值查询的场景，比如 Memcached 及其他一些 NoSQL 引擎

二叉搜索树也是课本里的经典数据结构了。还是上面根据身份证号查名字的例子，如果我们用二叉搜索树来实现的话，示意图如下所示：
![./basis_index_A_BinaryTree.webp](二叉搜索树示例)
二叉搜索树的特点是：父节点左子树所有结点的值小于父节点的值，右子树所有结点的值大于父节点的值。这样如果你要查 ID_card_n2 的话，按照图中的搜索顺序就是按照 UserA -> UserC -> UserF -> User2 这个路径得到。这个时间复杂度是 O(log(N))。

树可以有二叉，也可以有多叉。多叉的树就是每个节点有多个儿子，儿子之间的大小保证从左到右递增。二叉树是搜索效率最高的，但是实际上多数的数据库存储却并并不适用二叉树。期原因是，索引不止存在内存中还要写到磁盘上。

你可以想象一下，一颗100万节点的平衡二叉树，树高20，一次查询可能呢个需要访问20个数据块。再机械硬盘时代，从磁盘随机读取一个数据块需要10ms左右的寻址时间。也就是说，对于一个100万行的数据表，如果使用二叉树来存储，单独访问一个行可能需要200毫秒的时间，这个查询太慢了。

为了让一个查询尽量少地读磁盘，就必须让查询过程访问尽量少的数据块。那么，我们就不应该使用二叉树，而是要使用“N 叉”树。这里，“N 叉”树中的“N”取决于数据块的大小。以 InnoDB 的一个整数字段索引为例，这个 N 差不多是 1200。这棵树高是 4 的时候，就可以存 1200 的 3 次方个值，这已经 17 亿了。考虑到树根的数据块总是在内存中的，一个 10 亿行的表上一个整数字段的索引，查找一个值最多只需要访问 3 次磁盘。其实，树的第二层也有很大概率在内存中，那么访问磁盘的平均次数就更少了。N 叉树由于在读写上的性能优点，以及适配磁盘的访问模式，已经被广泛应用在数据库引擎中了。

不管是哈希，线性表还是Ｎ叉树，他们都是不断迭代的产物或者解决方案。数据库技术发展到今天，跳表，LSM树等数据结构也被用于引擎设计中，这里不再赘述。

你心里要有个概念，数据库底层存储的核心就是基于这些数据模型的。每次碰到一个新数据库，我们需要先关注他的数据模型，这样才能从理论上分析出这个数据库的适用场景。

 */

 /*
  InnoDB 的索引模型
  每一个索引在InnoDB中都对应一个Ｂ+(Balance+)树。
  假设我们有个主键列为ID的表，表中有字段Ｋ，并在Ｋ上有索引。
  */

-- 创建表结构
create table T(
id int primary key,
k int not null,
name varchar(16),
index (k)
)engine=InnoDB;

-- 插入测试数据
insert into T(id,k) values(100,1),(200,2),(300,3),(500,5),(600,6);

/*
 表中 R1~R5 的 (ID,k) 值分别为 (100,1)、(200,2)、(300,3)、(500,5) 和 (600,6)，两棵树的示例示意图如下。
 ![./basis_innoDB_index_BinaryTree.webp]()
 */

-- 如果语句是 select * from T where ID=500，即主键查询方式
SELECT t.* FROM t t WHERE ID = 500;

SELECT t.* FROM runner.t t
     WHERE ID = 500
     LIMIT 501;

-- 如果语句是 select * from T where k=5，即普通索引查询方式
select * from T where k = 5;
