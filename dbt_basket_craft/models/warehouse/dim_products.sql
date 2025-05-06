/* The purpose of staging vs warehouse. 
Staging holds views of the raw data 
Warehouse holds the final tables so that it's quicker
Staging (views) has to do calculations (joins, aggregations, window functions, etc)
Warehouse (tables) is the final product so we only have to take it straight from the table

Goes into Dev Schema -- 
dbt run --select dim_products --> to run in terminal
Now it's in DEV schema but we NEED to put it into production
Now we have to target production, but when we put it into production, won't add dev underscore __
We created MACRO beforehand that will manipulate schema name based on target
Target = Production --> Schema = prod

**Typical work flow**
Built it --> tested it --> push to production

Pushed it using "dbt run --select dim_products --target prod" to move into Warehouse table
*/

WITH stg_products AS (   
    SELECT * FROM 
    {{ ref('stg_products') }}
),dim_products AS (   
    SELECT       
    product_id,       
    product_name,       
    product_description,       
    created_at,       
    CURRENT_TIMESTAMP AS loaded_at   
    FROM stg_products
)
SELECT * FROM dim_products