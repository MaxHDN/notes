/*
Navicat MySQL Data Transfer

Source Server         : baiduyun_mysql
Source Server Version : 50644
Source Host           : 182.61.58.124:3306
Source Database       : mybatis

Target Server Type    : MYSQL
Target Server Version : 50644
File Encoding         : 65001

Date: 2020-05-25 23:53:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('1', '熊大', '男', '2020-05-25', '森林');
INSERT INTO `user` VALUES ('2', '熊二', '男', '2020-05-25', '森林');
INSERT INTO `user` VALUES ('3', '齐齐国王', '男', '2020-05-25', '花果山');
INSERT INTO `user` VALUES ('4', '光头强', '男', '2020-05-07', '木屋');
INSERT INTO `user` VALUES ('5', '小仙女', '女', '2020-05-23', '仙界');
