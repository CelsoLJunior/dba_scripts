column begin_snap new_value begin_snap noprint;
column end_snap new_value end_snap noprint;
column inst_num new_value inst_num noprint;
column dbidinsert new_value dbidinsert noprint;

select dbid dbidinsert from v$database;
select min(SNAP_ID) begin_snap from STATS$SNAPSHOT where SNAP_TIME between sysdate-30 and sysdate;
select max(SNAP_ID) end_snap from STATS$SNAPSHOT where SNAP_TIME between sysdate-30 and sysdate;
select 1 inst_num from dual;



insert into stats$temp_sqlstats
  ( old_hash_value, text_subset, module
  , delta_buffer_gets, delta_executions, delta_cpu_time
  , delta_elapsed_time, avg_hard_parse_time, delta_disk_reads, delta_parse_calls
  , max_sharable_mem, last_sharable_mem
  , delta_version_count, max_version_count, last_version_count
  , delta_cluster_wait_time, delta_rows_processed
  )
 select old_hash_value, text_subset, module
      , delta_buffer_gets, delta_executions, delta_cpu_time
      , delta_elapsed_time, avg_hard_parse_time, delta_disk_reads, delta_parse_calls
      , max_sharable_mem, last_sharable_mem
      , delta_version_count, max_version_count, last_version_count
      , delta_cluster_wait_time, delta_rows_processed
  from ( select -- sum deltas
                old_hash_value
              , text_subset
              , module
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address) 
                                or (buffer_gets < prev_buffer_gets)
                              then buffer_gets
                              else buffer_gets - prev_buffer_gets
                         end
                   end)                    delta_buffer_gets
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (executions < prev_executions)
                              then executions
                              else executions - prev_executions
                         end
                    end)                   delta_executions
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (cpu_time < prev_cpu_time)
                              then cpu_time
                              else cpu_time - prev_cpu_time
                         end
                    end)                  delta_cpu_time
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (elapsed_time < prev_elapsed_time)
                              then elapsed_time
                              else elapsed_time - prev_elapsed_time
                         end
                    end)                  delta_elapsed_time
              , avg(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else avg_hard_parse_time
                    end)                  avg_hard_parse_time
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (disk_reads < prev_disk_reads)
                              then disk_reads
                              else disk_reads - prev_disk_reads
                         end
                    end)                   delta_disk_reads
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (parse_calls < prev_parse_calls)
                              then parse_calls
                              else parse_calls - prev_parse_calls
                         end
                    end)                   delta_parse_calls
              , max(sharable_mem)          max_sharable_mem
              , sum(case when snap_id = &&end_snap
                         then last_sharable_mem
                         else 0
                    end)                   last_sharable_mem
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (version_count < prev_version_count)
                              then version_count
                              else version_count - prev_version_count
                         end
                    end)                   delta_version_count
              , max(version_count)         max_version_count
              , sum(case when snap_id = &&end_snap
                         then last_version_count
                         else 0
                    end)                   last_version_count
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (cluster_wait_time < prev_cluster_wait_time)
                              then cluster_wait_time
                              else cluster_wait_time - prev_cluster_wait_time
                         end
                    end)                   delta_cluster_wait_time
              , sum(case
                    when snap_id = &&begin_snap and prev_snap_id = -1 
                    then 0
                    else
                         case when (address != prev_address)
                                or (rows_processed < prev_rows_processed)
                              then rows_processed
                              else rows_processed - prev_rows_processed
                         end
                    end)                   delta_rows_processed
          from (select /*+ first_rows */
                       -- windowing function
                       snap_id
                     , old_hash_value
                     , text_subset
                     , module
                     , (lag(snap_id, 1, -1) 
                       over (partition by old_hash_value
                                        , dbid
                                        , instance_number
                            order by snap_id))    prev_snap_id
                     , (lead(snap_id, 1, -1)
                       over (partition by old_hash_value
                                        , dbid
                                        , instance_number
                            order by snap_id))    next_snap_id
                     , address
                     ,(lag(address, 1, hextoraw(0)) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_address
                     , buffer_gets
                     ,(lag(buffer_gets, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_buffer_gets
                     , cpu_time
                     ,(lag(cpu_time, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_cpu_time
                     , executions
                     ,(lag(executions, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_executions
                     , elapsed_time
                     ,(lag(elapsed_time, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_elapsed_time
                     , avg_hard_parse_time
                     , disk_reads
                     ,(lag(disk_reads, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_disk_reads
                     , parse_calls
                     ,(lag(parse_calls, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_parse_calls
                     , sharable_mem
                     ,(last_value(sharable_mem) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   last_sharable_mem
                     ,(lag(sharable_mem, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_sharable_mem
                     , version_count
                     ,(lag(version_count, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_version_count
                     ,(last_value(version_count) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   last_version_count
                     , cluster_wait_time
                     ,(lag(cluster_wait_time, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_cluster_wait_time
                     , rows_processed
                     ,(lag(rows_processed, 1, 0) 
                       over (partition by old_hash_value 
                                        , dbid
                                        , instance_number
                             order by snap_id))   prev_rows_processed
                from stats$sql_summary s
               where s.snap_id between &&begin_snap and &&end_snap
                 and s.dbid            = &&dbidinsert
                 and s.instance_number = &&inst_num
               )
        group by old_hash_value
               , text_subset
               , module
       )
 where delta_buffer_gets       > 0
    or delta_executions        > 0
    or delta_cpu_time          > 0
    or delta_disk_reads        > 0
    or delta_parse_calls       > 0
    or delta_cluster_wait_time > 0;