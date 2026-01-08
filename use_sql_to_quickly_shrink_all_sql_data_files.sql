use master;
set nocount on
 
declare @shrinkfiles    varchar(max)
set @shrinkfiles    = ''
select  @shrinkfiles    = @shrinkfiles +
'use [' + sd.name + '];' + char(10) +
'dbcc shrinkfile (' + cast(smf.file_id as varchar(3)) + ');' + char(10) from    sys.databases sd
join sys.database_mirroring sdm on sd.database_id = sdm.database_id join sys.master_files smf on sd.database_id = smf.database_id where sd.database_id > 4
and sd.state_desc = 'online'
and sdm.mirroring_role_desc is null
or  sdm.mirroring_role_desc != 'mirror'
and smf.type < 3
order by
sd.database_id asc
exec    (@shrinkfiles)
