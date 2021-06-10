delimiter //
drop procedure if exists sp_add_or_mod_table_column;
create procedure sp_add_or_mod_table_column(in `dbname` text, in `tablename` text, in `columnname` text, in `columntype` text, in `columnafter` text)
begin
	set @preparedstatement = (select if(
		(
			select count(*) from information_schema.columns
			where
				(table_name = tablename)
				and (table_schema = dbname)
				and (column_name = columnname)
		) > 0,
		concat("alter table ", tablename, " modify column `", columnname, "` ", columntype, " after `", columnafter, "`;"),
		concat("alter table ", tablename, " add column `",    columnname, "` ", columntype, " after `", columnafter, "`;")
	));

	prepare stmt from @preparedstatement;
	execute stmt;
	deallocate prepare stmt;
end;

drop procedure if exists sp_add_or_mod_hist_table_column;
create procedure sp_add_or_mod_hist_table_column(in `dbname` text, in `tablename` text, in `columnname` text, in `columntype` text, in `columnafter` text)
begin
	declare exit handler for sqlexception begin get diagnostics condition 1 @sqlstate = returned_sqlstate, @errno = mysql_errno, @text = message_text; 
		set @full_error = concat("error ", @errno, " (", @sqlstate, "): ", @text); 
		select @full_error; 
	end; 

	begin
		declare cur cursor for select table_name from information_schema.tables where table_schema = dbname and table_name regexp concat('^', tablename, '_[0-9]{6}$');
		open cur;
		call sp_add_or_mod_table_column(dbname, tablename, columnname, columntype, columnafter);

		begin
			declare sql_table_name varchar(200) default '';

			declare done int default 0;
			declare continue handler for not found set done = 1;
			repeat
				fetch next from cur into sql_table_name;
				if not done THEN
					call sp_add_or_mod_table_column(dbname, sql_table_name, columnname, columntype, columnafter);
				end if;
			until done end repeat;
		end;
		close cur;
	end;
end;

drop procedure if exists sp_drop_table_column_if_exists;
create procedure sp_drop_table_column_if_exists(in `dbname` text, in `tablename` text, in `columnname` text)
begin
		if exists (select * from information_schema.columns where table_schema = dbname and table_name = tablename and column_name = columnname) then
        	set @preparedstatement = concat("alter table ", tablename, " drop column `", columnname, "`;");
					prepare stmt from @preparedstatement;
					execute stmt;
					deallocate prepare stmt;
    end if;
end//

-- 删除一个字段
call sp_drop_table_column_if_exists(database(), "tb_player_detail_pd", "cross_immortals_fight_honour_seasonal");

-- 新增 或 修改 一个字段
call sp_add_or_mod_table_column(database(), "tb_player", "cross_immortals_fight_honour_seasonal", "bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '赛季跨服仙域荣耀'", "practice_level");
