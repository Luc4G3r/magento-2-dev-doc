SET @sku = "";
SET @org_qty = 0;
SET @org_qty_reserved = 0;
SET @org_date = "2000-01-01 00:00:00";

SELECT
	cpe.entity_id,
	cpe.sku,
	cpe.updated_at,
	@org_qty quantity_originial,
	@org_qty_reserved quantity_reserved_original,
	csi.qty quantity_stock,
	(SELECT
		SUM(ir.quantity)
		FROM inventory_reservation ir
		WHERE ir.sku = @sku
	) quantity_reserved,
	(SELECT
		SUM(soi.qty_ordered)
		FROM sales_order_item soi
		WHERE soi.product_id = cpe.entity_id
		AND soi.created_at >= @org_date
	) quantity_ordered,
	(SELECT
		SUM(soi.qty_invoiced)
		FROM sales_order_item soi
		WHERE soi.product_id = cpe.entity_id
		AND soi.created_at >= @org_date
	) quantity_invoiced,
	(SELECT
		SUM(soi.qty_refunded)
		FROM sales_order_item soi
		WHERE soi.product_id = cpe.entity_id
		AND soi.created_at >= @org_date
	) quantity_refunded,
	(SELECT
		SUM(soi.qty_canceled)
		FROM sales_order_item soi
		WHERE soi.product_id = cpe.entity_id
		AND soi.created_at >= @org_date
	) quantity_canceled,
	(SELECT
		SUM(soi.qty_shipped)
		FROM sales_order_item soi
		WHERE soi.product_id = cpe.entity_id
		AND soi.created_at >= @org_date
	) quantity_shipped
FROM catalog_product_entity cpe
LEFT JOIN cataloginventory_stock_item csi
	ON csi.product_id = cpe.entity_id
WHERE
	cpe.sku = @sku
