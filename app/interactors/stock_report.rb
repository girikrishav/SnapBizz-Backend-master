class StockReport
  include Interactor

  def perform
    store_id = context[:store_id]
    group_by = context[:group_by] || 'distributor'
    
    stock_report_list = []
    if group_by == 'DISTRIBUTOR'
      distributor_list = Distributor.where(:store_id => Digest::MD5::hexdigest(store_id))
      distributor_list.each do |distributor|
        all_revenue_profit = get_all_stock_profit_revenue(store_id, 'distributor', distributor.id)
        excess_revenue_profit = get_excess_stock_profit_revenue(store_id, 'distributor', distributor.id)
        shortage_revenue_profit = get_shortage_stock_profit_revenue(store_id, 'distributor', distributor.id)
        stock_report_list << {
          filterName: distributor.agency_name,
          allStockValue: ((a=get_all_stock_value(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["stock_value"] : 0.0),
          allStockSku: ((a=get_all_stock_sku_count(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["sku_count"] : 0.0),
          allStockProfit: (all_revenue_profit.count > 0 ? all_revenue_profit[0]["profit"] : 0.0),
          allStockRevenue: (all_revenue_profit.count > 0 ? all_revenue_profit[0]["revenue"] : 0.0),
          allDaysofStock: ((a=get_all_days_of_stock(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["days_of_stock"] : 0.0),
          excessStockValue: ((a=get_excess_stock_value(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["stock_value"] : 0.0),
          excessStockSku: ((a=get_excess_stock_sku_count(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["sku_count"] : 0.0),
          excessStockProfit: (excess_revenue_profit.count > 0 ? excess_revenue_profit[0]["profit"] : 0.0),
          excessStockRevenue: (excess_revenue_profit.count > 0 ? excess_revenue_profit[0]["revenue"] : 0.0),
          excessDaysofStock: ((a=get_excess_days_of_stock(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["days_of_stock"] : 0.0),
          shortageStockValue: ((a=get_shortage_stock_value(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["stock_value"] : 0.0),
          shortageStockSku: ((a=get_shortage_stock_sku_count(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["sku_count"] : 0.0),
          shortageStockProfit: (shortage_revenue_profit.count > 0 ? shortage_revenue_profit[0]["profit"] : 0.0),
          shortageStockRevenue: (shortage_revenue_profit.count > 0 ? shortage_revenue_profit[0]["revenue"] : 0.0),
          shortageDaysofStock: ((a=get_shortage_days_of_stock(store_id, 'distributor', distributor.id)).count > 0 ? a[0]["days_of_stock"] : 0.0)
        }  
      end
    else
      categories = Category.where(:parent_id => nil)
      categories.each do |category|
        all_revenue_profit = get_all_stock_profit_revenue(store_id, 'category', category.id)
        excess_revenue_profit = get_excess_stock_profit_revenue(store_id, 'category', category.id)
        shortage_revenue_profit = get_shortage_stock_profit_revenue(store_id, 'category', category.id)
        stock_report_list << {
          filterName: category.name,
          allStockValue: ((a=get_all_stock_value(store_id, 'category', category.id)).count > 0 ? a[0]["stock_value"] : 0.0),
          allStockSku: ((a=get_all_stock_sku_count(store_id, 'category', category.id)).count > 0 ? a[0]["sku_count"] : 0.0),
          allStockProfit: (all_revenue_profit.count > 0 ? all_revenue_profit[0]["profit"] : 0.0),
          allStockRevenue: (all_revenue_profit.count > 0 ? all_revenue_profit[0]["revenue"] : 0.0),
          allDaysofStock: ((a=get_all_days_of_stock(store_id, 'category', category.id)).count > 0 ? a[0]["days_of_stock"] : 0.0),
          excessStockValue: ((a=get_excess_stock_value(store_id, 'category', category.id)).count > 0 ? a[0]["stock_value"] : 0.0),
          excessStockSku: ((a=get_excess_stock_sku_count(store_id, 'category', category.id)).count > 0 ? a[0]["sku_count"] : 0.0),
          excessStockProfit: (excess_revenue_profit.count > 0 ? excess_revenue_profit[0]["profit"] : 0.0),
          excessStockRevenue: (excess_revenue_profit.count > 0 ? excess_revenue_profit[0]["revenue"] : 0.0),
          excessDaysofStock: ((a=get_excess_days_of_stock(store_id, 'category', category.id)).count > 0 ? a[0]["days_of_stock"] : 0.0),
          shortageStockValue: ((a=get_shortage_stock_value(store_id, 'category', category.id)).count > 0 ? a[0]["stock_value"] : 0.0),
          shortageStockSku: ((a=get_shortage_stock_sku_count(store_id, 'category', category.id)).count > 0 ? a[0]["sku_count"] : 0.0),
          shortageStockProfit: (shortage_revenue_profit.count > 0 ? shortage_revenue_profit[0]["profit"] : 0.0),
          shortageStockRevenue: (shortage_revenue_profit.count > 0 ? shortage_revenue_profit[0]["revenue"] : 0.0),
          shortageDaysofStock: ((a=get_shortage_days_of_stock(store_id, 'category', category.id)).count > 0 ? a[0]["days_of_stock"] : 0.0)
        }
      end
    end
    context[:stock_report] = stock_report_list
  end

  private
  def get_all_stock_value(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          SELECT 
            dist_prod.distributor_id as distributor_id, sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN distributor_products as dist_prod ON dist_prod.id = inv.product_id
          WHERE dist_prod.distributor_id = #{id}
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          SELECT 
            prod.category_id as category_id, sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN products as prod ON inv.product_id = prod.id
          WHERE inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.category_id = #{id}
          GROUP BY category_id")
    end
  end

  def get_all_stock_sku_count(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          SELECT 
            dist_prod.distributor_id as distributor_id, count(dist_prod.product_id) as sku_count
          FROM distributor_products as dist_prod
          WHERE dist_prod.id = #{id}
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          SELECT 
            prod.category_id as category_id, count(prod.id) as sku_count
          FROM products as prod
          WHERE prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.category_id = #{id}
          GROUP BY category_id")
    end
  end

  def get_all_stock_profit_revenue(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          SELECT 
            dist_prod.distributor_id as distributor_id,  
            sum(cust_tx_prod.line_item_total) as revenue, 
            sum(cust_tx_prod.line_item_profit) as profit
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = cust_tx_prod.product_id
          WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND dist_prod.distributor_id = #{id}
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          SELECT 
            prod.category_id as category_id, 
            sum(cust_tx_prod.line_item_total) as revenue, 
            sum(cust_tx_prod.line_item_profit) as profit
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
          WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.category_id = #{id}
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY category_id")
    end
  end

  def get_all_days_of_stock(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          SELECT 
            dist_prod.distributor_id as distributor_id,
            round((sum(in_stock_quantity) / avg(quantity)),2) as days_of_stock
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN inventories as inv ON cust_tx_prod.product_id = inv.product_id
          INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = cust_tx_prod.product_id
          WHERE dist_prod.distributor_id = #{id}
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          SELECT 
            prod.category_id as category_id,
            round((sum(in_stock_quantity) / avg(quantity)),2) as days_of_stock
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN inventories as inv ON cust_tx_prod.product_id = inv.product_id
          INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
          WHERE prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.category_id = #{id}
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY category_id")
    end
  end

  def get_excess_stock_value(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT cust_tx_prod.product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products as cust_tx_prod
            WHERE cust_tx_prod.product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY cust_tx_prod.product_id  
          )
          SELECT
            dist_prod.distributor_id as distributor_id, sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          INNER JOIN distributor_products as dist_prod ON sto_det.product_id = dist_prod.product_id
          WHERE dist_prod.distributor_id = #{id}
          AND ((select sum(in_stock_quantity) from inventories where id = inv.id) > sto_det.maximum_stock)
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products as cust_tx_prod
            INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
            WHERE prod.category_id = #{id}
            AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            prod.category_id as category_id, sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN products as prod ON prod.id = inv.product_id
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where id = inv.id) > sto_det.maximum_stock)
          AND prod.category_id = #{id}
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          GROUP BY category_id")
    end
  end

  def get_excess_stock_sku_count(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products
            WHERE product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            dist_prod.distributor_id as distributor_id, count(dist_prod.product_id) as sku_count
          FROM distributor_products as dist_prod
          INNER JOIN stock_details as sto_det ON dist_prod.product_id = sto_det.product_id
          WHERE dist_prod.distributor_id = #{id} 
          AND ((select sum(in_stock_quantity) from inventories where product_id = dist_prod.product_id) > sto_det.maximum_stock)
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products as cust_tx_prod
            INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
            WHERE prod.category_id = #{id}
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT
            prod.category_id as category_id, count(prod.id) as sku_count
          FROM products as prod
          INNER JOIN stock_details as sto_det ON prod.id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where product_id = prod.id) > sto_det.maximum_stock)
          AND prod.category_id = #{id}
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          GROUP BY category_id")
    end
  end

  def get_excess_stock_profit_revenue(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products
            WHERE product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            dist_prod.distributor_id as distributor_id,
            sum(cust_tx_prod.line_item_profit) as profit,
            sum(cust_tx_prod.line_item_total) as revenue
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
          INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
          WHERE dist_prod.distributor_id = #{id} 
          AND ((select sum(in_stock_quantity) from inventories where product_id = cust_tx_prod.product_id) > sto_det.maximum_stock)
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
        WITH stock_details AS (
          SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
          WHERE prod.category_id = #{id}
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY product_id  
        )
        SELECT 
          prod.category_id as category_id,
          sum(cust_tx_prod.line_item_profit) as profit,
          sum(cust_tx_prod.line_item_total) as revenue
        FROM customer_transaction_products as cust_tx_prod
        INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
        INNER JOIN products as prod ON prod.id = sto_det.product_id
        WHERE ((select sum(in_stock_quantity) from inventories where product_id = cust_tx_prod.product_id) > sto_det.maximum_stock)
        AND prod.category_id = #{id}
        AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
        AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
        AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
        GROUP BY category_id")
    end
  end

  def get_excess_days_of_stock(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(avg(quantity),2) as avg_daily_sales, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products
            WHERE product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            dist_prod.distributor_id as distributor_id,
            (sum(inv.in_stock_quantity) / avg(cust_tx_prod.quantity)) as days_of_stock
          FROM inventories as inv
          INNER JOIN customer_transaction_products as cust_tx_prod ON inv.product_id = cust_tx_prod.product_id
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
          WHERE dist_prod.distributor_id = #{id} 
          AND ((select sum(in_stock_quantity) from inventories where id = inv.id) > sto_det.maximum_stock)
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'            
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'          
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(avg(quantity),2) as avg_daily_sales, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((15*(sum(quantity) / avg(quantity))),2) as maximum_stock
            FROM customer_transaction_products as cust_tx_prod
            INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
            WHERE prod.category_id = #{id}
            AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'            
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            prod.category_id as category_id,
            round((sum(inv.in_stock_quantity) / avg(cust_tx_prod.quantity)),2) as days_of_stock
          FROM inventories as inv
          INNER JOIN customer_transaction_products as cust_tx_prod ON inv.product_id = cust_tx_prod.product_id
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          INNER JOIN products as prod ON prod.id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where id = inv.id) > sto_det.maximum_stock)
          AND prod.category_id = #{id}
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'            
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'          
          GROUP BY category_id")
    end
  end

  #SHORTAGE

  def get_shortage_stock_value(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT cust_tx_prod.product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products as cust_tx_prod
            WHERE cust_tx_prod.product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY cust_tx_prod.product_id  
          )
          SELECT
            dist_prod.distributor_id as distributor_id, sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          INNER JOIN distributor_products as dist_prod ON sto_det.product_id = dist_prod.product_id
          WHERE dist_prod.distributor_id = #{id}
          AND ((select sum(in_stock_quantity) from inventories where id = inv.id) <= sto_det.minimum_stock)
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products as cust_tx_prod
            INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
            WHERE prod.category_id = #{id}
            AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            prod.category_id as category_id, sum(inv.mrp) as stock_value
          FROM inventories as inv
          INNER JOIN products as prod ON prod.id = inv.product_id
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where id = inv.id) <= sto_det.minimum_stock)
          AND prod.category_id = #{id}
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          GROUP BY category_id")
    end
  end

  def get_shortage_stock_sku_count(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products
            WHERE product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            dist_prod.distributor_id as distributor_id, count(dist_prod.product_id) as sku_count
          FROM distributor_products as dist_prod
          INNER JOIN stock_details as sto_det ON dist_prod.product_id = sto_det.product_id
          WHERE dist_prod.distributor_id = #{id} 
          AND ((select sum(in_stock_quantity) from inventories where id = dist_prod.product_id) <= sto_det.minimum_stock)
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products as cust_tx_prod
            INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
            WHERE prod.category_id = #{id}
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT
            prod.category_id as category_id, count(inv.product_id) as sku_count
          FROM inventories as inv
          INNER JOIN products as prod ON prod.id = inv.product_id
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where id = inv.id) <= sto_det.minimum_stock)
          AND prod.category_id = #{id}
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          GROUP BY category_id")
    end
  end

  def get_shortage_stock_profit_revenue(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products
            WHERE product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            dist_prod.distributor_id as distributor_id,
            sum(cust_tx_prod.line_item_profit) as profit,
            sum(cust_tx_prod.line_item_total) as revenue
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
          INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
          WHERE dist_prod.distributor_id = #{id} 
          AND ((select sum(in_stock_quantity) from inventories where product_id = cust_tx_prod.product_id) <= sto_det.minimum_stock)
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
        WITH stock_details AS (
          SELECT product_id, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
          FROM customer_transaction_products as cust_tx_prod
          INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
          WHERE prod.category_id = #{id}
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
          GROUP BY product_id  
        )
        SELECT 
          prod.category_id as category_id,
          sum(cust_tx_prod.line_item_profit) as profit,
          sum(cust_tx_prod.line_item_total) as revenue
        FROM customer_transaction_products as cust_tx_prod
        INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
        INNER JOIN products as prod ON prod.id = sto_det.product_id
        WHERE ((select sum(in_stock_quantity) from inventories where product_id = cust_tx_prod.product_id) <= sto_det.minimum_stock)
        AND prod.category_id = #{id}
        AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
        AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
        AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
        GROUP BY category_id")
    end
  end

  def get_shortage_days_of_stock(store_id, group_by='distributor', id)
    if group_by == 'DISTRIBUTOR'
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(avg(quantity),2) as avg_daily_sales, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products
            WHERE product_id IN (SELECT product_id FROM distributor_products WHERE distributor_id = #{id})
            AND store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            dist_prod.distributor_id as distributor_id,
            round((sum(inv.in_stock_quantity) / avg(cust_tx_prod.quantity)),2) as days_of_stock
          FROM inventories as inv
          INNER JOIN customer_transaction_products as cust_tx_prod ON inv.product_id = cust_tx_prod.product_id
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
          WHERE dist_prod.distributor_id = #{id} 
          AND ((select sum(in_stock_quantity) from inventories where id = inv.id) <= sto_det.minimum_stock)
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'            
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'          
          GROUP BY distributor_id")
    else
      ActiveRecord::Base.connection.execute("
          WITH stock_details AS (
            SELECT product_id, round(avg(quantity),2) as avg_daily_sales, round(sum(quantity) / avg(quantity),2) as days_of_stock, round((2*(sum(quantity) / avg(quantity))),2) as minimum_stock
            FROM customer_transaction_products as cust_tx_prod
            INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
            WHERE prod.category_id = #{id}
            AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
            AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'            
            AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
            GROUP BY product_id  
          )
          SELECT 
            prod.category_id as category_id,
            round((sum(inv.in_stock_quantity) / avg(cust_tx_prod.quantity)),2) as days_of_stock
          FROM inventories as inv
          INNER JOIN customer_transaction_products as cust_tx_prod ON inv.product_id = cust_tx_prod.product_id
          INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
          INNER JOIN products as prod ON prod.id = sto_det.product_id
          WHERE ((select sum(in_stock_quantity) from inventories where id = inv.id) <= sto_det.minimum_stock)
          AND prod.category_id = #{id}
          AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
          AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'            
          AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'          
          GROUP BY category_id")
    end
  end

  #ORIGINALS
  # def get_all_stock_value(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           dist.agency_name, dist.tablet_db_id, sum(inv.mrp) as stock_value
  #         FROM inventories as inv
  #         INNER JOIN products as prod ON inv.product_id = prod.id
  #         INNER JOIN distributor_products as dist_prod ON prod.id = dist_prod.product_id
  #         INNER JOIN distributors as dist ON dist_prod.distributor_id = dist.id
  #         WHERE inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY dist.tablet_db_id, dist.agency_name")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           cat.name, sum(inv.mrp) as stock_value
  #         FROM inventories as inv
  #         INNER JOIN products as prod ON inv.product_id = prod.id
  #         RIGHT OUTER JOIN categories as cat ON prod.category_id = cat.id
  #         WHERE inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND cat.parent_id = null
  #         GROUP BY cat.name")
  #   end
  # end
  # #ORIGINALS
  # def get_all_stock_sku_count(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           dist.tablet_db_id, count(dist_prod.product_id)
  #         FROM distributor_products as dist_prod
  #         INNER JOIN distributors as dist ON dist_prod.distributor_id = dist.id
  #         WHERE dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY dist.tablet_db_id, dist.agency_name")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           cat.name, count(prod.id)
  #         FROM products as prod
  #         INNER JOIN categories as cat ON cat.id = prod.category_id
  #         WHERE prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY cat.name")
  #   end
  # end
  # #ORIGINALS
  # def get_all_stock_profit_revenue(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           dist.agency_name as distributor_agency, 
  #           dist.tablet_db_id as dist_tablet_db_id, 
  #           sum(cust_tx_prod.line_item_total) as revenue, 
  #           sum(cust_tx_prod.line_item_profit) as profit
  #         FROM customer_transaction_products as cust_tx_prod
  #         INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = cust_tx_prod.product_id
  #         INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
  #         WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY distributor_agency, dist_tablet_db_id")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           cat.name, sum(cust_tx_prod.line_item_total) as revenue, 
  #           sum(cust_tx_prod.line_item_profit) as profit
  #         FROM customer_transaction_products as cust_tx_prod
  #         INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
  #         INNER JOIN categories as cat ON cat.id = prod.category_id
  #         WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY cat.name")
  #   end
  # end
  # #ORIGINALS
  # def get_all_days_of_stock(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           dist.agency_name as distributor_agency, 
  #           dist.tablet_db_id as dist_tablet_db_id, 
  #           sum(quantity) / (sum(quantity)/180) as days_of_stock
  #         FROM customer_transaction_products as cust_tx_prod
  #         INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = cust_tx_prod.product_id
  #         INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
  #         WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY distributor_agency, dist_tablet_db_id")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         SELECT 
  #           cat.name, sum(quantity) / (sum(quantity)/180) as days_of_stock
  #         FROM customer_transaction_products as cust_tx_prod
  #         INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
  #         INNER JOIN categories as cat ON cat.id = prod.category_id
  #         WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY cat.name")
  #   end
  # end
  #ORIGINALS
  # def get_excess_stock_value(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #           FROM customer_transaction_products as cust_tx_prod
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           dist.agency_name, dist.tablet_db_id, sum(inv.mrp) as stock_value
  #         FROM inventories as inv
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         INNER JOIN distributor_products as dist_prod ON sto_det.product_id = dist_prod.product_id
  #         INNER JOIN distributors as dist ON dist_prod.distributor_id = dist.id
  #         WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY dist.tablet_db_id, dist.agency_name")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #           FROM customer_transaction_products as cust_tx_prod
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           cat.name, sum(inv.mrp) as stock_value
  #         FROM inventories as inv
  #         INNER JOIN products as prod ON prod.id = inv.product_id
  #         INNER JOIN categories as cat ON cat.id = prod.id
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY cat.name")
  #   end
  # end
  # #ORIGINALS
  # def get_excess_stock_sku_count(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           dist.tablet_db_id, count(dist_prod.product_id)
  #         FROM distributor_products as dist_prod
  #         INNER JOIN stock_details as sto_det ON dist_prod.product_id = sto_det.product_id
  #         INNER JOIN distributors as dist ON dist_prod.distributor_id = dist.id
  #         WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY dist.tablet_db_id, dist.agency_name")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT
  #           cat.name, count(inv.product_id)
  #         FROM inventories as inv
  #         INNER JOIN products as prod ON prod.id = inv.product_id
  #         INNER JOIN categories as cat ON cat.id = prod.category_id
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY cat.name")
  #   end
  # end

  # def get_excess_stock_profit_revenue(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           dist.agency_name as distributor_agency, 
  #           dist.tablet_db_id as dist_tablet_db_id, 
  #           sum(cust_tx_prod.line_item_profit) as profit,
  #           sum(cust_tx_prod.line_item_total) as revenue
  #         FROM customer_transaction_products as cust_tx_prod
  #         INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
  #         INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
  #         INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
  #         WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #         AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY distributor_agency, dist_tablet_db_id")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #       WITH stock_details AS (
  #         SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #         FROM customer_transaction_products
  #         WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY product_id  
  #       )
  #       SELECT 
  #         cat.name, 
  #         sum(cust_tx_prod.line_item_profit) as profit,
  #         sum(cust_tx_prod.line_item_total) as revenue
  #       FROM customer_transaction_products as cust_tx_prod
  #       INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
  #       INNER JOIN products as prod ON prod.id = sto_det.product_id
  #       INNER JOIN categories as cat ON cat.id = prod.category_id
  #       WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #       AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #       AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
  #       GROUP BY cat.name")
  #   end
  # end

  # def get_excess_days_of_stock(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT dist.agency_name as distributor_agency, 
  #           dist.tablet_db_id as dist_tablet_db_id, 
  #           sum(inv.in_stock_quantity)
  #         FROM inventories as inv
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
  #         INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
  #         WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY distributor_agency, dist_tablet_db_id")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           cat.name,
  #           sum(inv.in_stock_quantity)
  #         FROM inventories as inv
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         INNER JOIN products as prod ON prod.id = sto_det.product_id
  #         INNER JOIN categories as cat ON cat.id = prod.category_id
  #         WHERE sto_det.days_of_stock > sto_det.maximum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY cat.name")
  #   end
  # end
  
  # def get_shortage_stock_value(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #           FROM customer_transaction_products as cust_tx_prod
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           dist.agency_name, dist.tablet_db_id, sum(inv.mrp) as stock_value
  #         FROM inventories as inv
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         INNER JOIN distributor_products as dist_prod ON sto_det.product_id = dist_prod.product_id
  #         INNER JOIN distributors as dist ON dist_prod.distributor_id = dist.id
  #         WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY dist.tablet_db_id, dist.agency_name")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #           FROM customer_transaction_products as cust_tx_prod
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           cat.name, sum(inv.mrp) as stock_value
  #         FROM inventories as inv
  #         INNER JOIN products as prod ON prod.id = inv.product_id
  #         INNER JOIN categories as cat ON cat.id = prod.id
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY cat.name")
  #   end
  # end
  
  # def get_shortage_stock_sku_count(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           dist.tablet_db_id, count(dist_prod.product_id)
  #         FROM distributor_products as dist_prod
  #         INNER JOIN stock_details as sto_det ON dist_prod.product_id = sto_det.product_id
  #         INNER JOIN distributors as dist ON dist_prod.distributor_id = dist.id
  #         WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY dist.tablet_db_id, dist.agency_name")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT
  #           cat.name, count(inv.product_id)
  #         FROM inventories as inv
  #         INNER JOIN products as prod ON prod.id = inv.product_id
  #         INNER JOIN categories as cat ON cat.id = prod.category_id
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY cat.name")
  #   end
  # end

  # def get_shortage_stock_profit_revenue(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           dist.agency_name as distributor_agency, 
  #           dist.tablet_db_id as dist_tablet_db_id, 
  #           sum(cust_tx_prod.line_item_profit) as profit,
  #           sum(cust_tx_prod.line_item_total) as revenue
  #         FROM customer_transaction_products as cust_tx_prod
  #         INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
  #         INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
  #         INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
  #         WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #         AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY distributor_agency, dist_tablet_db_id")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #       WITH stock_details AS (
  #         SELECT product_id, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #         FROM customer_transaction_products
  #         WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND date >= CURRENT_DATE - INTERVAL '180 days'
  #         GROUP BY product_id  
  #       )
  #       SELECT 
  #         cat.name, 
  #         sum(cust_tx_prod.line_item_profit) as profit,
  #         sum(cust_tx_prod.line_item_total) as revenue
  #       FROM customer_transaction_products as cust_tx_prod
  #       INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
  #       INNER JOIN products as prod ON prod.id = sto_det.product_id
  #       INNER JOIN categories as cat ON cat.id = prod.category_id
  #       WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #       AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #       AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
  #       GROUP BY cat.name")
  #   end
  # end

  # def get_shortage_days_of_stock(store_id, group_by='distributor')
  #   if group_by == 'DISTRIBUTOR'
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT dist.agency_name as distributor_agency, 
  #           dist.tablet_db_id as dist_tablet_db_id, 
  #           sum(inv.in_stock_quantity)
  #         FROM inventories as inv
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
  #         INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
  #         WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
  #         AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY distributor_agency, dist_tablet_db_id")
  #   else
  #     ActiveRecord::Base.connection.execute("
  #         WITH stock_details AS (
  #           SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock
  #           FROM customer_transaction_products
  #           WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #           AND date >= CURRENT_DATE - INTERVAL '180 days'
  #           GROUP BY product_id  
  #         )
  #         SELECT 
  #           cat.name,
  #           sum(inv.in_stock_quantity)
  #         FROM inventories as inv
  #         INNER JOIN stock_details as sto_det ON inv.product_id = sto_det.product_id
  #         INNER JOIN products as prod ON prod.id = sto_det.product_id
  #         INNER JOIN categories as cat ON cat.id = prod.category_id
  #         WHERE sto_det.days_of_stock <= sto_det.minimum_stock
  #         AND inv.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         AND prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
  #         GROUP BY cat.name")
  #   end
  # end

    # all_stock_revenue = ActiveRecord::Base.connection.execute("
    #     SELECT 
    #       dist.agency_name as distributor_agency, 
    #       dist.tablet_db_id as dist_tablet_db_id, 
    #       sum(cust_tx_prod.line_item_total) as revenue
    #     FROM customer_transaction_products as cust_tx_prod
    #     INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = cust_tx_prod.product_id
    #     INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
    #     WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #     AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #     AND date >= CURRENT_DATE - INTERVAL '180 days'
    #     GROUP BY distributor_agency, dist_tablet_db_id")

    # excess_stock_revenue = ActiveRecord::Base.connection.execute("
    #     WITH stock_details AS (
    #       SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
    #       FROM customer_transaction_products
    #       WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #       AND date >= CURRENT_DATE - INTERVAL '180 days'
    #       GROUP BY product_id  
    #     )      
    #     SELECT 
    #       dist.agency_name as distributor_agency, 
    #       dist.tablet_db_id as dist_tablet_db_id, 
    #       sum(cust_tx_prod.line_item_total) as revenue
    #     FROM customer_transaction_products as cust_tx_prod
    #     INNER JOIN stock_details as sto_det ON cust_tx_prod.product_id = sto_det.product_id
    #     INNER JOIN distributor_products as dist_prod ON dist_prod.product_id = sto_det.product_id
    #     INNER JOIN distributors as dist ON dist.id = dist_prod.distributor_id
    #     WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #     AND dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #     AND date >= CURRENT_DATE - INTERVAL '180 days'
    #     GROUP BY distributor_agency, dist_tablet_db_id")


    #     WITH stock_profit_revenue AS (
    #       SELECT product_id, sum(cust_tx_prod.quantity * cust_tx_prod.sale_price) as revenue, sum(cust_tx_prod.quantity) as sold_quantity
    #       FROM customer_transaction_products as cust_tx_prod
    #       INNER JOIN distributor_products as dist_prod.product_id = cust_tx_prod.product_id
    #       INNER JOIN distributors as dist ON dist_prod.distributor_id = dist.id
    #       WHERE dist.store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #       AND cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}' 
    #       AND cust_tx_prod.date >= CURRENT_DATE - INTERVAL '180 days'
    #       GROUP BY product_id
    #       )
    #     SELECT * 
    #     FROM stock_profit_revenue
    #     WHERE
    #DONE Days of stock = total no of units (pieces/kgs/ltrs) of stock available / avg daily sales of units (pieces/kgs/ltrs) of that stock
    #DONE Minimum Stock Qty (MnSQ) = 2 * Avg. Daily Sales of stock in Volume
    #DONE Maximum Stock Qty (MxSQ) = 15 * Avg. Daily Sales of stock in Volume
    #DONE Excess Stock= Days of stock > MxSQ
    #DONE Low stock (Or shortage)= Days of Stock <= MnSQ

    
    # AVG Daily Sales:
    # SELECT product_id, sum(quantity)/180 as avg_daily_sales
    # FROM customer_transaction_products
    # WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}' 
    # AND date >= CURRENT_DATE - INTERVAL '180 days'
    # GROUP BY product_id

    # Days of Stock:
    # SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
    # FROM customer_transaction_products
    # WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}' 
    # AND date >= CURRENT_DATE - INTERVAL '180 days'
    # GROUP BY product_id

    # Excess 
    #   WITH stock_details AS (
    #   SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
    #   FROM customer_transaction_products
    #   WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #   AND date >= CURRENT_DATE - INTERVAL '180 days'
    #   GROUP BY product_id  
    #   )
    # SELECT * 
    # FROM stock_details
    # WHERE days_of_stock > maximum_stock

    # Low Stock:
    # WITH stock_details AS (
    #   SELECT product_id, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (2*(sum(quantity) / (sum(quantity)/180))) as minimum_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
    #   FROM customer_transaction_products
    #   WHERE store_id = '#{Digest::MD5::hexdigest(store_id)}'
    #   AND date >= CURRENT_DATE - INTERVAL '180 days'
    #   GROUP BY product_id  
    #   )
    # SELECT * 
    # FROM stock_details
    # WHERE days_of_stock <= minimum_stock
    # SELECT cat.name, sum(quantity)/180 as avg_daily_sales, sum(quantity) / (sum(quantity)/180) as days_of_stock, (15*(sum(quantity) / (sum(quantity)/180))) as maximum_stock
    # FROM customer_transaction_products as cust_tx_prod
    # INNER JOIN products as prod ON cust_tx_prod.product_id = prod.id
    # INNER JOIN categories as cat ON cat.id = prod.category_id
    # WHERE cust_tx_prod.store_id = '#{Digest::MD5::hexdigest(store_id)}'
    # AND date >= CURRENT_DATE - INTERVAL '180 days'
    # GROUP BY cat.name")
end
