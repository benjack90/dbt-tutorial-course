with order_items_summary as (
    SELECT
        oi.order_id,
        count(distinct case when oi.order_item_returned_at is not null then oi.order_item_id end) as order_item_returned_count,
        count(distinct case when oi.order_item_shipped_at is not null and oi.order_item_delivered_at is null then oi.order_item_id end) as order_items_in_transit_count
    FROM
        {{ ref('stg_ecommerce__order_items')}} oi
    group by
        1
),


user_order_details as (
    SELECT
    o.user_id,
    count(distinct o.order_id) as user_order_count,
    count(distinct case when o.order_returned_at is not null then o.order_id end) as user_returned_order_count,
    sum(o.num_items_ordered) as user_total_items_ordered,
    sum(o.total_order_sale_price) as user_total_sale,
    sum(o.total_order_profit) as user_total_profit,
    sum(o.total_order_discount) as user_total_discount,
    sum(case when o.order_returned_at is not null then o.total_order_sale_price end) as user_returned_sale_amount,
    count(distinct case when ois.order_item_returned_count = o.num_items_ordered then o.order_id end) as user_returned_all_items_order_count,
    sum(ois.order_item_returned_count) as returned_order_items,
    sum(ois.order_items_in_transit_count) as user_order_items_in_transit

    FROM
    {{ ref('dim_orders') }} as o
    left join order_items_summary as ois on ois.order_id = o.order_id

    group by 1

)

SELECT
uod.user_id,
date(foc.first_order_created_at) as user_first_order_date,
/*User Order Details*/
uod.user_order_count,
uod.user_total_items_ordered,
uod.user_order_items_in_transit,

/* Returns Details */
uod.user_returned_order_count,
uod.user_returned_sale_amount,
uod.user_returned_all_items_order_count,
uod.returned_order_items,

/* Total User Value */
uod.user_total_sale,
uod.user_total_profit,
uod.user_total_discount,
uod.user_returned_all_items_order_count/uod.user_order_count as user_returned_order_rate

FROM
user_order_details as uod
left join {{ ref('int_ecommerce__first_order_created') }} as foc on foc.user_id = uod.user_id