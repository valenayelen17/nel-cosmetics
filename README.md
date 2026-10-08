# NEL COSMETICS

E-commerce de cosmética artesanal desarrollado como proyecto integral de portfolio.

NEL COSMETICS busca implementar una solución completa de comercio electrónico para la gestión y venta de productos cosméticos, integrando una aplicación web, una API REST, una aplicación móvil y una base de datos MySQL.

---

## 📌 Descripción

El proyecto contempla el desarrollo de un sistema de e-commerce para la gestión de productos cosméticos, clientes, domicilios y pedidos.

El sistema permitirá consultar productos, gestionar usuarios, realizar pedidos, controlar stock y realizar el seguimiento del estado de las compras.

La solución estará compuesta por:

- Aplicación web desarrollada con Laravel.
- API REST para la comunicación entre sistemas.
- Aplicación móvil Android.
- Base de datos MySQL.
- Documentación técnica y funcional.

---

## 🎯 Objetivos

- Desarrollar un e-commerce funcional.
- Implementar una base de datos relacional.
- Aplicar reglas de negocio mediante triggers y procedimientos almacenados.
- Desarrollar una API REST.
- Integrar la API con una aplicación web y una aplicación móvil.
- Implementar autenticación y gestión de roles.
- Controlar stock y pedidos.
- Documentar el proceso completo de desarrollo.

---

## 👥 Actores

El sistema contempla principalmente los siguientes actores:

### Cliente

Puede:

- Registrarse e iniciar sesión.
- Consultar productos.
- Consultar categorías.
- Gestionar sus domicilios.
- Realizar pedidos.
- Consultar sus pedidos.
- Consultar el estado de sus pedidos.

### Administrador

Puede:

- Gestionar productos.
- Gestionar categorías.
- Gestionar stock.
- Gestionar pedidos.
- Actualizar estados de los pedidos.
- Consultar información del sistema.

---

## 🏗️ Arquitectura

La arquitectura general del sistema estará compuesta por una aplicación web, una aplicación móvil y una API REST conectadas con la base de datos.

**NEL COSMETICS**

- 🌐 Website
  - Laravel

- 📱 App Mobile
  - Android

- 🔌 REST API
  - Comunicación entre las aplicaciones y la base de datos

- 🗄️ MySQL
  - Persistencia de datos

## 🗄️ Base de datos

La base de datos utilizada es MySQL/MariaDB.

El modelo contempla las siguientes entidades principales:

- Roles
- Usuarios
- Domicilios
- Categorías
- Productos
- Estados de pedido
- Pedidos
- Historial de estados de pedidos
- Productos asociados a pedidos

### Funcionalidades implementadas

- Relaciones entre entidades mediante claves foráneas.
- Datos iniciales de prueba.
- Control automático de stock.
- Cálculo automático de precios y subtotales.
- Cálculo automático del total de los pedidos.
- Historial de estados.
- Validación de cambios de estado.
- Restauración del stock al cancelar pedidos.
- Vistas para consultas y reportes.
- Procedimientos almacenados para operaciones principales.

## 🛠️ Tecnologías
Backend / Web
- PHP
- Laravel
- MySQL / MariaDB
- REST API
Mobile
- Android
- Java
Base de datos
- MySQL Workbench
- MySQL / MariaDB
- SQL
Herramientas
- Visual Studio Code
- Git
- GitHub
- GitHub Desktop
🧪 Pruebas realizadas
La base de datos fue probada mediante un flujo completo de pedido:
Crear pedido
     ↓
Pedido pendiente
     ↓
Agregar producto
     ↓
Descontar stock
     ↓
Calcular subtotal
     ↓
Calcular total
     ↓
Confirmar pedido
     ↓
Registrar historial
     ↓
Cancelar pedido
     ↓
Restaurar stock

Las pruebas verificaron correctamente el funcionamiento de:
- Creación de pedidos.
- Agregado de productos.
- Control de stock.
- Cálculo de subtotales.
- Cálculo de totales.
- Cambio de estados.
- Historial de estados.
- Cancelación de pedidos.
- Restauración de stock.
📊 Estado del proyecto
Componente	Estado
Requerimientos	✅ Completado
Modelo de base de datos	✅ Completado
Base de datos MySQL	✅ Completado
Datos iniciales	✅ Completado
Triggers	✅ Completado
Vistas SQL	✅ Completado
Procedimientos almacenados	✅ Completado
API REST	🚧 En desarrollo
Aplicación web Laravel	🚧 Pendiente
Aplicación Android	🚧 Pendiente
Documentación final	🚧 En desarrollo


🚀 Próximos pasos
1. Desarrollar la API REST.
2. Implementar autenticación.
3. Desarrollar el e-commerce web con Laravel.
4. Integrar la aplicación web con la API.
5. Desarrollar la aplicación móvil Android.
6. Realizar pruebas de integración.
7. Completar la documentación técnica.
👩‍💻 Autora
Valentina de Jesús
Proyecto desarrollado como portfolio para demostrar conocimientos en desarrollo de software, bases de datos, backend, aplicaciones web y aplicaciones móviles.