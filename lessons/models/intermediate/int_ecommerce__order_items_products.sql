with products as (
  SELECT
    product_id,
	product_department,
    retail_price,
	product_cost
  FROM
    {{ ref('stg_ecommerce__products')}}

)

SELECT

	oi.order_item_id,
	oi.order_id,
	oi.user_id,
	oi.product_id,

	oi.item_sale_price,

	p.product_department,
	p.retail_price,
	p.product_cost,

	oi.item_sale_price - p.product_cost as item_profit,
	p.retail_price - oi.item_sale_price as item_discount

FROM
	{{ ref('stg_ecommerce__order_items') }} oi
	LEFT JOIN products p on p.product_id = oi.product_id