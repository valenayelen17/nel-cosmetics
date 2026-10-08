-- NEL COSMETICS - 01_schema.sql
-- Compatible con MySQL / MariaDB

DROP DATABASE IF EXISTS `nel_cosmetics`;
CREATE DATABASE `nel_cosmetics`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `nel_cosmetics`;

CREATE TABLE `Roles` (
    `id_rol` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(30) NOT NULL,
    PRIMARY KEY (`id_rol`)
) ENGINE=InnoDB;

CREATE TABLE `Usuarios` (
    `id_usuario` INT NOT NULL AUTO_INCREMENT,
    `fkRol` INT NOT NULL,
    `nombre` VARCHAR(50) NOT NULL,
    `apellido` VARCHAR(50) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `telefono` VARCHAR(20) NULL,
    `password` VARCHAR(255) NOT NULL,
    `fecha_alta` DATE NOT NULL,
    PRIMARY KEY (`id_usuario`),
    INDEX `fk_Usuarios_Roles_idx` (`fkRol`),
    CONSTRAINT `fk_Usuarios_Roles`
        FOREIGN KEY (`fkRol`)
        REFERENCES `Roles` (`id_rol`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `Domicilios` (
    `id_domicilio` INT NOT NULL AUTO_INCREMENT,
    `fkUsuario` INT NOT NULL,
    `calle` VARCHAR(100) NOT NULL,
    `altura` VARCHAR(10) NOT NULL,
    `piso` VARCHAR(10) NULL,
    `departamento` VARCHAR(10) NULL,
    `localidad` VARCHAR(50) NOT NULL,
    `provincia` VARCHAR(50) NOT NULL,
    `codigo_postal` VARCHAR(10) NULL,
    PRIMARY KEY (`id_domicilio`),
    INDEX `fk_Domicilios_Usuarios1_idx` (`fkUsuario`),
    CONSTRAINT `fk_Domicilios_Usuarios1`
        FOREIGN KEY (`fkUsuario`)
        REFERENCES `Usuarios` (`id_usuario`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `Categorias` (
    `id_categoria` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(50) NOT NULL,
    `descripcion` VARCHAR(150) NULL,
    `activo` TINYINT NULL,
    PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB;

CREATE TABLE `Productos` (
    `id_producto` INT NOT NULL AUTO_INCREMENT,
    `fkCategoria` INT NOT NULL,
    `nombre` VARCHAR(100) NOT NULL,
    `descripcion` VARCHAR(255) NULL,
    `precio` DECIMAL(10,2) NOT NULL,
    `stock` INT NOT NULL,
    `imagen` VARCHAR(255) NULL,
    `activo` TINYINT NOT NULL,
    `fecha_alta` DATE NOT NULL,
    PRIMARY KEY (`id_producto`),
    INDEX `fk_Productos_Categorias1_idx` (`fkCategoria`),
    CONSTRAINT `fk_Productos_Categorias1`
        FOREIGN KEY (`fkCategoria`)
        REFERENCES `Categorias` (`id_categoria`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `Estados_pedido` (
    `id_estado` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(30) NOT NULL,
    `descripcion` VARCHAR(100) NULL,
    PRIMARY KEY (`id_estado`)
) ENGINE=InnoDB;

CREATE TABLE `Pedidos` (
    `id_pedido` INT NOT NULL AUTO_INCREMENT,
    `fkUsuario` INT NOT NULL,
    `fkEstado` INT NOT NULL,
    `fkDomicilio` INT NOT NULL,
    `fecha_pedido` DATETIME NOT NULL,
    `domicilio_entrega` VARCHAR(255) NOT NULL,
    `costo_envio` DECIMAL(10,2) NOT NULL,
    `total` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`id_pedido`),
    INDEX `fk_Pedidos_Usuarios1_idx` (`fkUsuario`),
    INDEX `fk_Pedidos_Domicilios1_idx` (`fkDomicilio`),
    INDEX `fk_Pedidos_Estados1_idx` (`fkEstado`),
    CONSTRAINT `fk_Pedidos_Usuarios1`
        FOREIGN KEY (`fkUsuario`)
        REFERENCES `Usuarios` (`id_usuario`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Pedidos_Domicilios1`
        FOREIGN KEY (`fkDomicilio`)
        REFERENCES `Domicilios` (`id_domicilio`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Pedidos_Estados1`
        FOREIGN KEY (`fkEstado`)
        REFERENCES `Estados_pedido` (`id_estado`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `Pedido_estados` (
    `id_pedido_estado` INT NOT NULL AUTO_INCREMENT,
    `fkEstado` INT NOT NULL,
    `fkPedido` INT NOT NULL,
    `fkUsuario` INT NOT NULL,
    `fecha_cambio` DATETIME NOT NULL,
    `observacion` VARCHAR(150) NULL,
    PRIMARY KEY (`id_pedido_estado`),
    INDEX `fk_Pedido_estados_Pedidos1_idx` (`fkPedido`),
    INDEX `fk_Pedido_estados_Estados_idx` (`fkEstado`),
    INDEX `fk_Pedido_estados_Usuarios_idx` (`fkUsuario`),
    CONSTRAINT `fk_Pedido_estados_Pedidos1`
        FOREIGN KEY (`fkPedido`)
        REFERENCES `Pedidos` (`id_pedido`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Pedido_estados_Estados`
        FOREIGN KEY (`fkEstado`)
        REFERENCES `Estados_pedido` (`id_estado`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Pedido_estados_Usuarios`
        FOREIGN KEY (`fkUsuario`)
        REFERENCES `Usuarios` (`id_usuario`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE=InnoDB;

CREATE TABLE `Pedidos_has_Productos` (
    `id_pedido_producto` INT NOT NULL AUTO_INCREMENT,
    `fkProducto` INT NOT NULL,
    `fkPedido` INT NOT NULL,
    `cantidad` INT NOT NULL,
    `precio_unitario` DECIMAL(10,2) NULL,
    `subtotal` DECIMAL(10,2) NULL,
    PRIMARY KEY (`id_pedido_producto`),
    INDEX `fk_Productos_has_Pedidos_Pedidos1_idx` (`fkPedido`),
    INDEX `fk_Productos_has_Pedidos_Productos1_idx` (`fkProducto`),
    CONSTRAINT `fk_Productos_has_Pedidos_Productos1`
        FOREIGN KEY (`fkProducto`)
        REFERENCES `Productos` (`id_producto`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_Productos_has_Pedidos_Pedidos1`
        FOREIGN KEY (`fkPedido`)
        REFERENCES `Pedidos` (`id_pedido`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
) ENGINE=InnoDB;
