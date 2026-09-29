# Catálogo de Datos de la Gold Layer

## Descripción general
La Gold Layer es la representación de los datos a nivel de negocio, estructurada para soportar casos de uso analíticos y de reportería. Está compuesta por **tablas de dimensión** y **tablas de hechos** para métricas de negocio específicas.

---

### 1. **gold.dim_customers**
- **Propósito:** Almacena los datos de los clientes, enriquecidos con información demográfica y geográfica.
- **Columnas:**

| Nombre de columna | Tipo de dato  | Descripción                                                                                      |
|-------------------|---------------|--------------------------------------------------------------------------------------------------|
| customer_key      | INT           | Surrogate key que identifica de forma única a cada registro de cliente en la tabla de dimensión.  |
| customer_id       | INT           | Identificador numérico único asignado a cada cliente.                                             |
| customer_number   | NVARCHAR(50)  | Identificador alfanumérico del cliente, usado para seguimiento y referencia.                      |
| first_name        | NVARCHAR(50)  | Nombre del cliente, tal como está registrado en el sistema.                                       |
| last_name         | NVARCHAR(50)  | Apellido del cliente.                                                                             |
| country           | NVARCHAR(50)  | País de residencia del cliente (ej. 'Australia').                                                 |
| marital_status    | NVARCHAR(50)  | Estado civil del cliente (ej. 'Married', 'Single').                                               |
| gender            | NVARCHAR(50)  | Género del cliente (ej. 'Male', 'Female', 'n/a').                                                 |
| birthdate         | DATE          | Fecha de nacimiento del cliente, con formato YYYY-MM-DD (ej. 1971-10-06).                         |
| create_date       | DATE          | Fecha en que se creó el registro del cliente en el sistema.                                       |

---

### 2. **gold.dim_products**
- **Propósito:** Contiene la información de los productos y sus atributos.
- **Columnas:**

| Nombre de columna    | Tipo de dato  | Descripción                                                                                           |
|----------------------|---------------|-------------------------------------------------------------------------------------------------------|
| product_key          | INT           | Surrogate key que identifica de forma única a cada producto en la tabla de dimensión.                 |
| product_id           | INT           | Identificador único asignado al producto para seguimiento y referencia interna.                       |
| product_number       | NVARCHAR(50)  | Código alfanumérico estructurado que representa al producto, usado para categorización o inventario.  |
| product_name         | NVARCHAR(50)  | Nombre descriptivo del producto, incluyendo detalles como tipo, color y talla.                        |
| category_id          | NVARCHAR(50)  | Identificador único de la categoría del producto, que lo vincula con su clasificación general.        |
| category             | NVARCHAR(50)  | Clasificación general del producto (ej. Bikes, Components), usada para agrupar artículos relacionados.|
| subcategory          | NVARCHAR(50)  | Clasificación más detallada del producto dentro de su categoría, como el tipo de producto.            |
| maintenance_required | NVARCHAR(50)  | Indica si el producto requiere mantenimiento (ej. 'Yes', 'No').                                       |
| cost                 | INT           | Costo o precio base del producto, expresado en unidades monetarias.                                   |
| product_line         | NVARCHAR(50)  | Línea o serie específica a la que pertenece el producto (ej. Road, Mountain).                         |
| start_date           | DATE          | Fecha en que el producto quedó disponible para la venta o uso.                                        |

---

### 3. **gold.fact_sales**
- **Propósito:** Almacena los datos transaccionales de ventas para fines analíticos.
- **Columnas:**

| Nombre de columna | Tipo de dato  | Descripción                                                                                       |
|-------------------|---------------|---------------------------------------------------------------------------------------------------|
| order_number      | NVARCHAR(50)  | Identificador alfanumérico único de cada orden de venta (ej. 'SO54496').                          |
| product_key       | INT           | Surrogate key que vincula la orden con la tabla de dimensión de productos.                        |
| customer_key      | INT           | Surrogate key que vincula la orden con la tabla de dimensión de clientes.                         |
| order_date        | DATE          | Fecha en que se colocó la orden.                                                                  |
| shipping_date     | DATE          | Fecha en que la orden fue enviada al cliente.                                                     |
| due_date          | DATE          | Fecha de vencimiento del pago de la orden.                                                        |
| sales_amount      | INT           | Valor monetario total de la venta para esa línea, en unidades monetarias enteras (ej. 25).        |
| quantity          | INT           | Cantidad de unidades del producto ordenadas en esa línea (ej. 1).                                 |
| price             | INT           | Precio por unidad del producto en esa línea, en unidades monetarias enteras (ej. 25).             |
