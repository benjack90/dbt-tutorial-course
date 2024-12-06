WITH source as (
	SELECT *
	FROM {{ source('thelook_ecommerce', 'products') }}
)

SELECT
	-- IDs
	id as product_id,


	-- Product details

	brand as product_brand,
	retail_price,
	cost as product_cost,
	department as product_department,

	{#Unused Columns:

	- sku
	- distribution_center_id
	- name
	- inventory_item_id
	- category

	#}

FROM
	source