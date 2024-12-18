{{ config(
    severity = 'warn'
)}}

/*

    Checks that each order id exists in both order items and the orders table. It also checks to make sure that
    the number of items in the orders table and the order items tables match for each order id.

*/

with order_details as (
    select
        order_id,
        count(*) as order_items_count,

    from {{ ref("stg_ecommerce__order_items") }}
    group by 1
)

select
    o.*,
    od.*

from

    {{ ref("stg_ecommerce__orders") }} o
    full outer join order_details od using(order_id)

where
    -- All orders must have an order id
    o.order_id is null
    or od.order_id is null
    -- The number of items ordered must match the number of items in the order details
    or o.num_of_items_ordered != od.order_items_count