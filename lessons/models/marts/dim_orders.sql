WITH

-- Aggregate measures
order_item_measures AS (
    SELECT
        order_id,
        SUM(item_sale_price) as total_order_sale_price,
        SUM(product_cost) as total_order_product_cost,
        SUM(item_profit) as total_order_profit,
        SUM(item_discount) as total_order_discount,
        {# set deparments manually for our for loop #}
        {%- set departments = ['Men','Women'] -%}

        {# use dbt_utils.get_column_values to extract all the possible column values dynamically #}
        {# {%- for department in dbt_utils.get_column_values(table=ref('int_ecommerce__order_items_products'),column='product_department') %} #}
        {%- for department in departments %}
        SUM(IF(product_department = '{{department}}', item_sale_price, 0)) as total_sold_{{department.lower()}}{{"," if not loop.last }}
        {%- endfor %}

    FROM
        {{ ref('int_ecommerce__order_items_products') }}
    GROUP BY 1
)

SELECT
    o.order_id,
    o.user_id,
    o.status as order_status,
    o.created_at as order_created_at,
    {{ is_weekend('o.created_at') }} as oder_date_is_weekend,
    o.shipped_at as order_shipped_at,
    {{ is_weekend('o.shipped_at') }} as order_shipped_is_weekend,
    o.delivered_at as order_delivered_at,
    o.returned_at as order_returned_at,
    o.num_of_items_ordered as num_items_ordered,
    om.total_order_sale_price,
    om.total_order_product_cost,
    om.total_order_profit,
    om.total_order_discount,
    user_data.first_order_created_at as user_first_order_created_at
    {%- for department in departments %}
    ,om.total_sold_{{department.lower()}}
    {%- endfor %}

FROM
    {{ ref('stg_ecommerce__orders') }} as o
    LEFT JOIN order_item_measures as om
        ON o.order_id = om.order_id
    LEFT JOIN {{ ref('int_ecommerce__first_order_created') }} as user_data
        ON o.user_id = user_data.user_id