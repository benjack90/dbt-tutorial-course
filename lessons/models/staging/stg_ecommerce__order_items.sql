

WITH source as (
	SELECT *
	FROM {{ source('thelook_ecommerce', 'order_items') }}
)

SELECT
	-- IDs
	id AS order_item_id,
	order_id,
	user_id,
	product_id,
    returned_at AS order_item_returned_at,
    shipped_at as order_item_shipped_at,
    delivered_at as order_item_delivered_at,
	-- Other columns
	sale_price AS item_sale_price


	{# Unused Columns

		- inventory_item_id

		For the below, we assume that all of these will be the same
		in stg_ecommerce__orders so we can use that as the source of truth
		(e.g. a whole order is returned, not just 1 item).
		This is a simplification for the purpose of this course.
		- gender
		- status
		- created_at
		- shipped_at
		- delivered_at
		- returned_at

	#}

FROM
	source
