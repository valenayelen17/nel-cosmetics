USE `nel_cosmetics`;

-- =====================================================
-- VISTA 1: PEDIDOS COMPLETOS
-- Información general de cada pedido
-- =====================================================

CREATE OR REPLACE VIEW `vw_pedidos_completos` AS
SELECT
    p.id_pedido,
    p.fecha_pedido,
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    u.email,
    e.nombre AS estado,
    p.domicilio_entrega,
    p.costo_envio,
    p.total
FROM Pedidos p
INNER JOIN Usuarios u
    ON p.fkUsuario = u.id_usuario
INNER JOIN Estados_pedido e
    ON p.fkEstado = e.id_estado;


-- =====================================================
-- VISTA 2: PRODUCTOS MÁS VENDIDOS
-- Ranking de productos según cantidad vendida
-- =====================================================

CREATE OR REPLACE VIEW `vw_productos_mas_vendidos` AS
SELECT
    pr.id_producto,
    pr.nombre AS producto,
    c.nombre AS categoria,
    SUM(pp.cantidad) AS unidades_vendidas,
    SUM(pp.subtotal) AS ingresos_generados
FROM Pedidos_has_Productos pp
INNER JOIN Productos pr
    ON pp.fkProducto = pr.id_producto
INNER JOIN Categorias c
    ON pr.fkCategoria = c.id_categoria
GROUP BY
    pr.id_producto,
    pr.nombre,
    c.nombre;


-- =====================================================
-- VISTA 3: VENTAS POR CATEGORÍA
-- =====================================================

CREATE OR REPLACE VIEW `vw_ventas_por_categoria` AS
SELECT
    c.id_categoria,
    c.nombre AS categoria,
    COUNT(DISTINCT pp.fkPedido) AS cantidad_pedidos,
    SUM(pp.cantidad) AS unidades_vendidas,
    SUM(pp.subtotal) AS total_ventas
FROM Categorias c
INNER JOIN Productos p
    ON c.id_categoria = p.fkCategoria
INNER JOIN Pedidos_has_Productos pp
    ON p.id_producto = pp.fkProducto
GROUP BY
    c.id_categoria,
    c.nombre;


-- =====================================================
-- VISTA 4: STOCK CRÍTICO
-- Productos con stock igual o inferior a 5 unidades
-- =====================================================

CREATE OR REPLACE VIEW `vw_stock_critico` AS
SELECT
    p.id_producto,
    p.nombre AS producto,
    c.nombre AS categoria,
    p.stock,
    p.precio
FROM Productos p
INNER JOIN Categorias c
    ON p.fkCategoria = c.id_categoria
WHERE p.stock <= 5
  AND p.activo = 1;


-- =====================================================
-- VISTA 5: CLIENTES FRECUENTES
-- Cantidad de pedidos y dinero gastado por cliente
-- =====================================================

CREATE OR REPLACE VIEW `vw_clientes_frecuentes` AS
SELECT
    u.id_usuario,
    CONCAT(u.nombre, ' ', u.apellido) AS cliente,
    u.email,
    COUNT(p.id_pedido) AS cantidad_pedidos,
    COALESCE(SUM(p.total), 0) AS total_gastado
FROM Usuarios u
INNER JOIN Pedidos p
    ON u.id_usuario = p.fkUsuario
GROUP BY
    u.id_usuario,
    u.nombre,
    u.apellido,
    u.email;


-- =====================================================
-- VISTA 6: TRAZABILIDAD DE PEDIDOS
-- Historial de cambios de estado
-- =====================================================

CREATE OR REPLACE VIEW `vw_trazabilidad_pedidos` AS
SELECT
    pe.id_pedido_estado,
    pe.fkPedido AS id_pedido,
    pe.fecha_cambio,
    e.nombre AS estado,
    CONCAT(u.nombre, ' ', u.apellido) AS usuario,
    pe.observacion
FROM Pedido_estados pe
INNER JOIN Estados_pedido e
    ON pe.fkEstado = e.id_estado
INNER JOIN Usuarios u
    ON pe.fkUsuario = u.id_usuario;