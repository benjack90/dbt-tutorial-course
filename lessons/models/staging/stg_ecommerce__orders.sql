{# {{
	config(
		materialized='view'
	)
}} #}

{# uncomment the previous few lines to overwrite configuration options for this model #}

WITH source AS (
        SELECT *

        FROM {{ source('thelook_ecommerce', 'orders') }}
)

SELECT
	-- IDs
        order_id,
        user_id,

	-- Datetimes
        created_at,
        returned_at,
        shipped_at,
        delivered_at,

	-- Order details
        status,
		num_of_item AS num_of_items_ordered

FROM source