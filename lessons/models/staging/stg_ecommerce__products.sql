WITH source as (
	SELECT *
	FROM {{ source('thelook_ecommerce', 'products') }}
)

SELECT
	-- IDs
	id as product_id,
	sku as product_sku,
	distribution_center_id

	-- Product details
	name as product_name,
	brand as product_brand,
	retail_price,
	category as product_category,
	cost as product_cost,
	department as product_department,
FROM
	source