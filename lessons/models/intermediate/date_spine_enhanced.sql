with enhanced_date_spine as (
    select
        date_day as the_date,
        format_timestamp('%A',date_day) as day_of_week_name,
        extract(dayofweek from date_day) as day_of_week_number,
        date_trunc(date_day, week(monday)) as week_start,
        extract(isoweek from date_day) as week_number,
        format_timestamp('%B', date_day) as month_name,
        format_timestamp('%Y-%m-%d', date_day) as month_year,
        extract(month from date_day) as month_number,
        extract(year from date_day) as year_number,
        concat('Q', extract(quarter from date_day), ' ', cast(extract(year from date_day) as string)) as quarter_name,
        false as is_federal_holiday
    from
        {{ ref('date_spine') }}
    where
        date_day between '2019-01-01' and current_date() + interval 1 day
)
select *
from enhanced_date_spine