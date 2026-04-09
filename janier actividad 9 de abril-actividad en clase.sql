create database if not exists tienda;
use tienda;

create table clientes (
    id_cliente int auto_increment primary key,
    nombre varchar(100) not null
);

create table productos (
    id_producto int auto_increment primary key,
    nombre varchar(100) not null,
    precio decimal(10,2) not null,
    stock int default 0
);

create table pedidos (
    id_pedido int auto_increment primary key,
    id_cliente int not null,
    fecha datetime default now(),
    estado enum('pendiente','enviado','entregado','cancelado') default 'pendiente',
    foreign key (id_cliente) references clientes(id_cliente)
);

create table detalle_pedido (
    id_detalle int auto_increment primary key,
    id_pedido int,
    id_producto int,
    cantidad int,
    foreign key (id_pedido) references pedidos(id_pedido),
    foreign key (id_producto) references productos(id_producto)
);


insert into clientes (nombre) values
('juan'),
('maria');

insert into productos (nombre, precio, stock) values
('laptop', 2500000, 10),
('mouse', 80000, 50),
('teclado', 150000, 30);

insert into pedidos (id_cliente, estado) values
(1, 'pendiente'),
(2, 'pendiente');

insert into detalle_pedido (id_pedido, id_producto, cantidad) values
(1, 1, 1),
(1, 2, 2),
(2, 3, 1);

/*procedimiento almacenado*/
delimiter $$

create procedure cancelar_pedido(
    in p_id_pedido int,
    in p_id_cliente int,
    out mensaje varchar(255)
)
begin
    declare v_existe int default 0;
    declare v_estado varchar(20);
    declare v_productos int default 0;

    /*validar existencia y pertenencia*/
    select count(*), estado
    into v_existe, v_estado
    from pedidos
    where id_pedido = p_id_pedido
      and id_cliente = p_id_cliente;

    if v_existe = 0 then
        set mensaje = 'no exitoso: el pedido no existe o no pertenece al cliente';

    else
        /*validar estado*/
        if v_estado in ('cancelado','entregado') then
            set mensaje = 'no exitoso: el pedido ya fue procesado';

        else
            /* cancelar pedido*/
            update pedidos
            set estado = 'cancelado'
            where id_pedido = p_id_pedido;

            /* restaurar stock*/
            update productos p
            join detalle_pedido dp on p.id_producto = dp.id_producto
            set p.stock = p.stock + dp.cantidad
            where dp.id_pedido = p_id_pedido;

            /*contar productos afectados*/
            select count(*)
            into v_productos
            from detalle_pedido
            where id_pedido = p_id_pedido;

            set mensaje = concat('exitoso: pedido ', p_id_pedido,
                                 ' cancelado, stock restaurado en ',
                                 v_productos, ' productos');
        end if;
    end if;

end $$

delimiter ;

/* prueba*/
call cancelar_pedido(1, 1, @mensaje);
select @mensaje;;

/* janier adrian chindoy jamioy*/

