create table clientes (
    id_cliente int auto_increment primary key,
    nombre varchar(100) not null
);

drop table if exists productos;

create table productos (
    id_producto int auto_increment primary key,
    nombre varchar(100) not null,
    precio decimal(10,2) not null
);

create table pedidos (
    id_pedido int auto_increment primary key,
    id_cliente int not null,
    fecha_pedido datetime default current_timestamp,
    estado enum('pendiente', 'enviado', 'entregado', 'cancelado'),
    total decimal(12,2) default 0,
    foreign key (id_cliente) references clientes(id_cliente)
    on delete cascade on update cascade
);

create table detalle_pedido(
    id_detalle int auto_increment primary key,
    id_pedido int not null, 
    id_producto int not null,
    precio_unit decimal(10,2) not null,
    foreign key(id_pedido) references pedidos(id_pedido)
    on delete cascade,
    foreign key(id_producto) references productos(id_producto)
);



insert into clientes (nombre) values
('Juan Perez'),
('Maria Gomez'),
('Carlos Lopez'),
('Ana Torres'),
('Luis Ramirez');

insert into productos (nombre, precio) values
('Laptop', 2500000),
('Mouse', 50000),
('Teclado', 120000),
('Monitor', 800000),
('Audifonos', 150000),
('Impresora', 600000);

insert into pedidos (id_cliente, estado) values
(1, 'pendiente'),
(2, 'enviado'),
(3, 'entregado'),
(1, 'cancelado'),
(4, 'pendiente');

insert into detalle_pedido (id_pedido, id_producto, precio_unit) values
(1, 1, 2500000),
(1, 2, 50000),

(2, 3, 120000),
(2, 5, 150000),

(3, 4, 800000),

(4, 2, 50000),
(4, 3, 120000),

(5, 6, 600000);


-- actualizar totales 

set sql_safe_updates = 0;
update pedidos p
set total = (
    select sum(dp.precio_unit)
    from detalle_pedido dp
    where dp.id_pedido = p.id_pedido
);


-- consulta de prueba


select 
    p.id_pedido,
    c.nombre as cliente,
    pr.nombre as producto,
    dp.precio_unit,
    p.total
from detalle_pedido dp
join pedidos p on dp.id_pedido = p.id_pedido
join clientes c on p.id_cliente = c.id_cliente
join productos pr on dp.id_producto = pr.id_producto;



/*tarea de mañana mostrar el cliente y ese pedido que productos tienen solo los que tnegan*/
select 
    c.nombre as cliente,
    p.id_pedido,
    p.estado,
    pr.nombre as producto,
    dp.precio_unit,
    p.total
from clientes c
inner join pedidos p on c.id_cliente = p.id_cliente
inner join detalle_pedido dp on p.id_pedido = dp.id_pedido
inner join productos pr on dp.id_producto = pr.id_producto;
