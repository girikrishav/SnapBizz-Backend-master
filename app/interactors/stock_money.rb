class StockMoney
  include Interactor

  def perform
    store_id = context[:store_id]
    context[:excess_stock_value] = ((a=get_excess_stock_value(store_id)).count > 0 ? a[0]["stock_value"] : 0.0)
    context[:low_stock_value] = ((a=get_low_stock_value(store_id)).count > 0 ? a[0]["stock_value"] : 0.0)
    context[:slow_stock_value] = ((a=get_slow_stock_value(store_id)).count > 0 ? a[0]["stock_value"] : 0.0)
  end

  private

  def get_excess_stock_value(store_id)
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT cust_tx_prod.product_id, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products as cust_tx_prod
            WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY cust_tx_prod.product_id
          )
          SELECT
            sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where id = inv.id) > sto_det.maximum_stock)
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'")
  end

  def get_low_stock_value(store_id)
    ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT cust_tx_prod.product_id, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products as cust_tx_prod
            WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY cust_tx_prod.product_id
          )
          SELECT
            sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where id = inv.id) <= sto_det.minimum_stock)
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'")
  end

  def get_slow_stock_value(store_id)
    ActiveRecord::Base.connection.execute("
      SELECT sum(inv.mrp) as stock_value
      FROM inventories as inv
      WHERE inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
      AND inv.product_id NOT IN (
        SELECT DISTINCT ON (product_id) product_id FROM customer_transaction_products WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}' AND date >= CURRENT_DATE - INTERVAL '2 weeks' )
    ")
  end
end
