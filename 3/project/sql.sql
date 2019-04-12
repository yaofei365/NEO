create table `sample` (
  `id` bigint(20) unsigned not null auto_increment comment '×ÔÔöid',
  `msg` varchar(20) collate utf8_unicode_ci not null comment 'ÄÚÈİ',
  primary key (`id`)
) engine=innodb default charset=utf8 collate=utf8_unicode_ci comment='²âÊÔ';