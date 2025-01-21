{# Generates a macro that checks to see if the date in question is a weekend day #}

{%- macro is_weekend(date_column) -%}
    EXTRACT(DAYOFWEEK FROM DATE({{ date_column }})) IN (1, 7)
{%- endmacro -%}