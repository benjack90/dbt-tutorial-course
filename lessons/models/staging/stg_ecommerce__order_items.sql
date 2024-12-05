

WITH source as (
	SELECT *
	FROM {{ source('thelook_ecommerce', 'order_items') }}
)

SELECT
	-- IDs
	id as order_item_id,
	order_id,
	user_id,
	product_id,
	inventory_item_id,

	-- Datetimes
	created_at,
	delivered_at,
	returned_at,

	-- Order details
	status,
	sale_price
FROM
	source
