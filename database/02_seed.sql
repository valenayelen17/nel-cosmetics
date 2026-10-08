USE `nel_cosmetics`;

-- =====================================================
-- ROLES
-- =====================================================

INSERT INTO `Roles` (`nombre`) VALUES
('Cliente'),
('Administrador');

-- =====================================================
-- ESTADOS DE PEDIDO
-- =====================================================

INSERT INTO `Estados_pedido` (`nombre`, `descripcion`) VALUES
('Pendiente', 'Pedido creado y pendiente de confirmación'),
('Confirmado', 'Pedido confirmado'),
('En preparacion', 'Pedido en preparación'),
('Enviado', 'Pedido enviado'),
('Entregado', 'Pedido entregado al cliente'),
('Cancelado', 'Pedido cancelado');

-- =====================================================
-- CATEGORÍAS
-- =====================================================

INSERT INTO `Categorias` (`nombre`, `descripcion`, `activo`) VALUES
('Cuidado facial', 'Productos para el cuidado y tratamiento facial', 1),
('Cuidado corporal', 'Productos para hidratar y cuidar el cuerpo', 1),
('Serums', 'Serums y tratamientos concentrados', 1),
('Cremas', 'Cremas hidratantes y de tratamiento', 1),
('Limpieza facial', 'Productos destinados a la limpieza facial', 1),
('Accesorios', 'Accesorios relacionados con el cuidado personal', 1);

-- =====================================================
-- USUARIO ADMINISTRADOR
-- =====================================================

INSERT INTO `Usuarios`
(`fkRol`, `nombre`, `apellido`, `email`, `telefono`, `password`, `fecha_alta`)
VALUES
(2, 'Valentina', 'Administrador', 'admin@nelcosmetics.com', '1123456789', '123456', CURDATE());

-- =====================================================
-- USUARIO CLIENTE
-- =====================================================

INSERT INTO `Usuarios`
(`fkRol`, `nombre`, `apellido`, `email`, `telefono`, `password`, `fecha_alta`)
VALUES
(1, 'Cliente', 'Prueba', 'cliente@nelcosmetics.com', '1167894321', '123456', CURDATE());

-- =====================================================
-- DOMICILIO
-- =====================================================

INSERT INTO `Domicilios`
(`fkUsuario`, `calle`, `altura`, `piso`, `departamento`,
 `localidad`, `provincia`, `codigo_postal`)
VALUES
(2, 'Av. Rivadavia', '12345', NULL, NULL,
 'Lomas del Mirador', 'Buenos Aires', '1752');

-- =====================================================
-- PRODUCTOS
-- =====================================================

INSERT INTO `Productos`
(`fkCategoria`, `nombre`, `descripcion`, `precio`, `stock`, `imagen`, `activo`, `fecha_alta`)
VALUES
(4, 'Crema de Urea 40%', 
 'Crema hidratante y reparadora para piel seca y áreas engrosadas',
 8500.00, 20, 'urea-40.jpg', 1, CURDATE()),

(4, 'Crema Niacinamida + Pantenol',
 'Crema hidratante y calmante que ayuda a mejorar la barrera de la piel',
 9500.00, 15, 'niacinamida-pantenol.jpg', 1, CURDATE()),

(3, 'Serum Facial',
 'Serum concentrado para complementar la rutina de cuidado facial',
 11000.00, 12, 'serum-facial.jpg', 1, CURDATE()),

(1, 'Crema Hidratante Facial',
 'Crema hidratante para uso diario',
 7800.00, 25, 'crema-hidratante.jpg', 1, CURDATE()),

(5, 'Limpiador Facial',
 'Producto para la limpieza diaria del rostro',
 7200.00, 18, 'limpiador-facial.jpg', 1, CURDATE());