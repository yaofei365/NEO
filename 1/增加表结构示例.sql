drop table if exists `tb_player_cross_immortals_fight_honour_weekly_reward_pd`;
create table `tb_player_cross_immortals_fight_honour_weekly_reward_pd` (
  `id` bigint(20) unsigned not null auto_increment comment '唯一id',
  `player_id` bigint(20) unsigned not null comment '玩家id',
  `reward_id` bigint(20) unsigned not null comment '对应配置表 cross_immortals_weekly_reward 的 reward_id',
  `reset_time` bigint(20) unsigned not null comment '与 weekly_reset_time 相等则表示已领取',
  `status` tinyint(4) unsigned not null,
  `created_date` datetime not null,
  `last_modified_date` datetime not null,
  primary key (`id`),
  key `index_1` (`player_id`) using btree
) engine=innodb default charset=utf8 collate=utf8_unicode_ci comment='玩家跨服仙域荣耀每周奖励表';
