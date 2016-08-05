(select 'vacuum analyze;')
union all
(select 'refresh materialized view geo.' || table_name || ';' from view_v('geo') where table_name not like 'TOTALS%')
union all
(select 'vacuum analyze;');
