USE nel_cosmetics;


-- ============================================================
-- PROCEDIMIENTO 1: CREAR PEDIDO
-- ============================================================

DROP PROCEDURE IF EXISTS sp_crear_pedido;

DELIMITER $$

CREATE PROCEDURE sp_crear_pedido(
    IN p_usuario INT,
    IN p_domicilio INT,
    IN p_costo_envio DECIMAL(10,2)
)
BEGIN

    DECLARE v_domicilio VARCHAR(255);

    -- Buscar el domicilio del usuario
    SELECT CONCAT(
        calle, ' ', altura,
        IF(piso IS NOT NULL AND piso <> '',
           CONCAT(', Piso ', piso), ''),
        IF(departamento IS NOT NULL AND departamento <> '',
           CONCAT(', Depto. ', departamento), ''),
        ', ', localidad,
        ', ', provincia,
        IF(codigo_postal IS NOT NULL AND codigo_postal <> '',
           CONCAT(' (CP ', codigo_postal, ')'), '')
    )
    INTO v_domicilio
    FROM Domicilios
    WHERE id_domicilio = p_domicilio
      AND fkUsuario = p_usuario;

    -- Verificar que exista el domicilio
    IF v_domicilio IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El domicilio no pertenece al usuario o no existe';

    END IF;

    -- Crear pedido en estado Pendiente
    INSERT INTO Pedidos (
        fkUsuario,
        fkEstado,
        fkDomicilio,
        fecha_pedido,
        domicilio_entrega,
        costo_envio,
        total
    )
    VALUES (
        p_usuario,
        1,
        p_domicilio,
        NOW(),
        v_domicilio,
        p_costo_envio,
        p_costo_envio
    );

    -- Mostrar resultado
    SELECT
        LAST_INSERT_ID() AS id_pedido,
        'Pedido creado correctamente' AS mensaje;

END$$

DELIMITER ;


-- ============================================================
-- PROCEDIMIENTO 2: AGREGAR PRODUCTO A UN PEDIDO
-- ============================================================

DROP PROCEDURE IF EXISTS sp_agregar_producto_pedido;

DELIMITER $$

CREATE PROCEDURE sp_agregar_producto_pedido(
    IN p_pedido INT,
    IN p_producto INT,
    IN p_cantidad INT
)
BEGIN

    DECLARE v_estado VARCHAR(30);
    DECLARE v_activo TINYINT;

    -- Verificar cantidad
    IF p_cantidad <= 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'La cantidad debe ser mayor a cero';

    END IF;

    -- Obtener estado actual del pedido
    SELECT e.nombre
    INTO v_estado
    FROM Pedidos p
    INNER JOIN Estados_pedido e
        ON p.fkEstado = e.id_estado
    WHERE p.id_pedido = p_pedido;

    -- Verificar que el pedido exista
    IF v_estado IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El pedido no existe';

    END IF;

    -- Solo se pueden modificar pedidos pendientes
    IF v_estado <> 'Pendiente' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Solo se pueden agregar productos a pedidos pendientes';

    END IF;

    -- Verificar que el producto exista y esté activo
    SELECT activo
    INTO v_activo
    FROM Productos
    WHERE id_producto = p_producto;

    IF v_activo IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El producto no existe';

    END IF;

    IF v_activo = 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El producto no esta disponible';

    END IF;

    -- Insertar producto en el pedido
    -- Los triggers calculan:
    -- precio_unitario
    -- subtotal
    -- stock
    -- total del pedido

    INSERT INTO Pedidos_has_Productos (
        fkProducto,
        fkPedido,
        cantidad
    )
    VALUES (
        p_producto,
        p_pedido,
        p_cantidad
    );

    SELECT
        'Producto agregado correctamente' AS mensaje;

END$$

DELIMITER ;


-- ============================================================
-- PROCEDIMIENTO 3: CAMBIAR ESTADO DEL PEDIDO
-- ============================================================

DROP PROCEDURE IF EXISTS sp_cambiar_estado_pedido;

DELIMITER $$

CREATE PROCEDURE sp_cambiar_estado_pedido(
    IN p_pedido INT,
    IN p_nuevo_estado INT,
    IN p_usuario INT
)
BEGIN

    DECLARE v_estado_actual VARCHAR(30);
    DECLARE v_estado_nuevo VARCHAR(30);

    -- Obtener estado actual
    SELECT e.nombre
    INTO v_estado_actual
    FROM Pedidos p
    INNER JOIN Estados_pedido e
        ON p.fkEstado = e.id_estado
    WHERE p.id_pedido = p_pedido;

    -- Verificar pedido
    IF v_estado_actual IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El pedido no existe';

    END IF;

    -- Obtener nuevo estado
    SELECT nombre
    INTO v_estado_nuevo
    FROM Estados_pedido
    WHERE id_estado = p_nuevo_estado;

    -- Verificar estado
    IF v_estado_nuevo IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El estado indicado no existe';

    END IF;

    -- ========================================================
    -- VALIDAR TRANSICIONES
    -- ========================================================

    IF NOT (

        -- Pendiente -> Confirmado
        (v_estado_actual = 'Pendiente'
         AND v_estado_nuevo = 'Confirmado')

        OR

        -- Pendiente -> Cancelado
        (v_estado_actual = 'Pendiente'
         AND v_estado_nuevo = 'Cancelado')

        OR

        -- Confirmado -> En preparacion
        (v_estado_actual = 'Confirmado'
         AND v_estado_nuevo = 'En preparacion')

        OR

        -- Confirmado -> Cancelado
        (v_estado_actual = 'Confirmado'
         AND v_estado_nuevo = 'Cancelado')

        OR

        -- En preparacion -> Enviado
        (v_estado_actual = 'En preparacion'
         AND v_estado_nuevo = 'Enviado')

        OR

        -- En preparacion -> Cancelado
        (v_estado_actual = 'En preparacion'
         AND v_estado_nuevo = 'Cancelado')

        OR

        -- Enviado -> Entregado
        (v_estado_actual = 'Enviado'
         AND v_estado_nuevo = 'Entregado')

    ) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Transicion de estado no permitida';

    END IF;

    -- Actualizar estado
    UPDATE Pedidos
    SET fkEstado = p_nuevo_estado
    WHERE id_pedido = p_pedido;

    -- Mostrar resultado
    SELECT
        'Estado actualizado correctamente' AS mensaje,
        v_estado_actual AS estado_anterior,
        v_estado_nuevo AS nuevo_estado;

END$$

DELIMITER ;


-- ============================================================
-- PROCEDIMIENTO 4: CANCELAR PEDIDO
-- ============================================================

DROP PROCEDURE IF EXISTS sp_cancelar_pedido;

DELIMITER $$

CREATE PROCEDURE sp_cancelar_pedido(
    IN p_pedido INT,
    IN p_usuario INT
)
BEGIN

    DECLARE v_estado VARCHAR(30);

    -- Obtener estado actual
    SELECT e.nombre
    INTO v_estado
    FROM Pedidos p
    INNER JOIN Estados_pedido e
        ON p.fkEstado = e.id_estado
    WHERE p.id_pedido = p_pedido;

    -- Verificar pedido
    IF v_estado IS NULL THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El pedido no existe';

    END IF;

    -- No permitir cancelar pedido entregado
    IF v_estado = 'Entregado' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'No se puede cancelar un pedido entregado';

    END IF;

    -- Evitar cancelar dos veces
    IF v_estado = 'Cancelado' THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'El pedido ya esta cancelado';

    END IF;

    -- ========================================================
    -- RESTAURAR STOCK
    -- ========================================================

    UPDATE Productos p
    INNER JOIN Pedidos_has_Productos pp
        ON p.id_producto = pp.fkProducto
    SET p.stock = p.stock + pp.cantidad
    WHERE pp.fkPedido = p_pedido;

    -- ========================================================
    -- CAMBIAR ESTADO A CANCELADO
    -- ========================================================

    UPDATE Pedidos
    SET fkEstado = 6
    WHERE id_pedido = p_pedido;

    SELECT
        'Pedido cancelado correctamente' AS mensaje;

END$$

DELIMITER ;


-- ============================================================
-- PROCEDIMIENTO 5: REPORTE GENERAL DE VENTAS
-- ============================================================

DROP PROCEDURE IF EXISTS sp_reporte_ventas;

DELIMITER $$

CREATE PROCEDURE sp_reporte_ventas()
BEGIN

    SELECT
        *
    FROM vw_productos_mas_vendidos
    ORDER BY unidades_vendidas DESC;

END$$

DELIMITER ;


-- ============================================================
-- VERIFICAR PROCEDIMIENTOS CREADOS
-- ============================================================

SHOW PROCEDURE STATUS
WHERE Db = 'nel_cosmetics';