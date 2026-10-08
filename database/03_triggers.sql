USE `nel_cosmetics`;

DELIMITER $$

-- =====================================================
-- TRIGGER 1
-- Validar stock y calcular subtotal al agregar producto
-- =====================================================

CREATE TRIGGER `trg_pedidos_productos_before_insert`
BEFORE INSERT ON `Pedidos_has_Productos`
FOR EACH ROW
BEGIN

    DECLARE v_precio DECIMAL(10,2);
    DECLARE v_stock INT;

    SELECT precio, stock
    INTO v_precio, v_stock
    FROM Productos
    WHERE id_producto = NEW.fkProducto;

    IF v_stock < NEW.cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para el producto seleccionado';
    END IF;

    SET NEW.precio_unitario = v_precio;
    SET NEW.subtotal = NEW.cantidad * v_precio;

END$$


-- =====================================================
-- TRIGGER 2
-- Descontar stock al agregar producto al pedido
-- =====================================================

CREATE TRIGGER `trg_pedidos_productos_after_insert`
AFTER INSERT ON `Pedidos_has_Productos`
FOR EACH ROW
BEGIN

    UPDATE Productos
    SET stock = stock - NEW.cantidad
    WHERE id_producto = NEW.fkProducto;

    UPDATE Pedidos
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0) + costo_envio
        FROM Pedidos_has_Productos
        WHERE fkPedido = NEW.fkPedido
    )
    WHERE id_pedido = NEW.fkPedido;

END$$


-- =====================================================
-- TRIGGER 3
-- Calcular subtotal al modificar cantidad
-- =====================================================

CREATE TRIGGER `trg_pedidos_productos_before_update`
BEFORE UPDATE ON `Pedidos_has_Productos`
FOR EACH ROW
BEGIN

    DECLARE v_stock INT;

    SELECT stock
    INTO v_stock
    FROM Productos
    WHERE id_producto = NEW.fkProducto;

    IF NEW.fkProducto = OLD.fkProducto THEN

        IF NEW.cantidad > OLD.cantidad
           AND v_stock < (NEW.cantidad - OLD.cantidad) THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Stock insuficiente para aumentar la cantidad';

        END IF;

    END IF;

    SET NEW.precio_unitario = OLD.precio_unitario;
    SET NEW.subtotal = NEW.cantidad * NEW.precio_unitario;

END$$


-- =====================================================
-- TRIGGER 4
-- Actualizar stock cuando cambia la cantidad
-- =====================================================

CREATE TRIGGER `trg_pedidos_productos_after_update`
AFTER UPDATE ON `Pedidos_has_Productos`
FOR EACH ROW
BEGIN

    IF NEW.fkProducto = OLD.fkProducto THEN

        UPDATE Productos
        SET stock = stock + OLD.cantidad - NEW.cantidad
        WHERE id_producto = NEW.fkProducto;

    ELSE

        UPDATE Productos
        SET stock = stock + OLD.cantidad
        WHERE id_producto = OLD.fkProducto;

        UPDATE Productos
        SET stock = stock - NEW.cantidad
        WHERE id_producto = NEW.fkProducto;

    END IF;

    UPDATE Pedidos
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0) + costo_envio
        FROM Pedidos_has_Productos
        WHERE fkPedido = NEW.fkPedido
    )
    WHERE id_pedido = NEW.fkPedido;

END$$


-- =====================================================
-- TRIGGER 5
-- Restaurar stock al eliminar un producto del pedido
-- =====================================================

CREATE TRIGGER `trg_pedidos_productos_after_delete`
AFTER DELETE ON `Pedidos_has_Productos`
FOR EACH ROW
BEGIN

    UPDATE Productos
    SET stock = stock + OLD.cantidad
    WHERE id_producto = OLD.fkProducto;

    UPDATE Pedidos
    SET total = (
        SELECT COALESCE(SUM(subtotal), 0) + costo_envio
        FROM Pedidos_has_Productos
        WHERE fkPedido = OLD.fkPedido
    )
    WHERE id_pedido = OLD.fkPedido;

END$$


-- =====================================================
-- TRIGGER 6
-- Registrar automáticamente el primer estado del pedido
-- =====================================================

CREATE TRIGGER `trg_pedidos_after_insert`
AFTER INSERT ON `Pedidos`
FOR EACH ROW
BEGIN

    INSERT INTO Pedido_estados
    (
        fkEstado,
        fkPedido,
        fkUsuario,
        fecha_cambio,
        observacion
    )
    VALUES
    (
        NEW.fkEstado,
        NEW.id_pedido,
        NEW.fkUsuario,
        NOW(),
        'Estado inicial del pedido'
    );

END$$


-- =====================================================
-- TRIGGER 7
-- Registrar cambios de estado del pedido
-- =====================================================

CREATE TRIGGER `trg_pedidos_after_update_estado`
AFTER UPDATE ON `Pedidos`
FOR EACH ROW
BEGIN

    IF OLD.fkEstado <> NEW.fkEstado THEN

        INSERT INTO Pedido_estados
        (
            fkEstado,
            fkPedido,
            fkUsuario,
            fecha_cambio,
            observacion
        )
        VALUES
        (
            NEW.fkEstado,
            NEW.id_pedido,
            NEW.fkUsuario,
            NOW(),
            'Cambio de estado del pedido'
        );

    END IF;

END$$


DELIMITER ;