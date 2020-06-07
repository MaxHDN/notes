# mysql常用命令

## 一、创建表

~~~mysql
-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50)  DEFAULT NULL,
  `password` varchar(50)  DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;
~~~

## 二、向表中插入数据

~~~mysql
-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '张三', '123');
INSERT INTO `user` VALUES (2, 'tom', '123');
~~~

## 三、增加表中的字段

~~~mysql
-- 对 table_name 新增 sort 字段 、类型为VARCHAR、 长度为20、默认为null、注释：排序字段
ALTER TABLE table_name ADD COLUMN sort VARCHAR(20) DEFAULT NULL COMMENT '排序字段'
~~~

## 四、修改表字段的类型

~~~mysql
-- alter table 表名 modify column 字段名 类型;
alter table table_name  modify column title varchar(130)
~~~

