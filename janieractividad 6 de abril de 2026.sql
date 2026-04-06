/*Sentencias de DDL*/
/*Creacion de base de datos*/
create database TiendaMascota;
/*Habilitar la base de datos*/
use TiendaMascota;
/*Creacion de tablas*/
create table Mascota(
idMascota int primary key,
nombreMascota varchar (15),
generoMascota varchar (15),
razaMascota varchar (15),
cantidad int (10)
);
create table Cliente(
cedulaCliente int primary key,
nombreCliente varchar (15),
apellidoCliente varchar (15),
direccionCliente varchar (10),
telefono int (10),
idMascotaFK int
);
create table Producto(
codigoProducto int primary key,
nombreProducto varchar (15),
marca varchar (15),
precio float,
cedulaClienteFK int
);
create table Vacuna(
codigoVacuna int primary key,
nombreVacuna varchar (15),
dosisVacuna int (10),
enfermedad varchar (15)
);
create table Mascota_Vacuna(
codigoVacunaFK int,
idMascotaFK int,
enfermedad varchar (15)
);

/*crear las relaciones*/
alter table Cliente
add constraint FClienteMascota
foreign key (idMascotaFK)
references Mascota(idMascota);

alter table Producto
add constraint FKProductoCliente
foreign key (cedulaClienteFK)
references Cliente(cedulaCliente);

alter table Mascota_Vacuna
add constraint FKMV
foreign key (idMascotaFK)
references Mascota(idMascota );

alter table Mascota_Vacuna
add constraint FKVM
foreign key (codigoVacunaFK)
references Vacuna(codigoVacuna);

/*Registro de datos  Insert  inset into nombreTable values(campos)
Campo numérico 123455
campo es caracter siempre esta en comillas
cpo es boolean 1 o 0
campo es date dd-mm-aaaa mm-dd-aaaa 
campo float o double debe ser un valor decimal
la relación se debe hacer inserción en la tabla que no de dependa de otra tabla
create table Mascota(
idMascota int primary key,
nombreMascota varchar (15),
generoMascota varchar (15),
razaMascota varchar (15),
cantidad int (10)
);

create table Cliente(
cedulaCliente int primary key,
nombreCliente varchar (15),
apellidoCliente varchar (15),
direccionCliente varchar (10),
telefono int (10),
idMascotaFK int
);
create table Producto(
codigoProducto int primary key,
nombreProducto varchar (15),
marca varchar (15),
precio float,
cedulaClienteFK int
);
*/

insert into Mascota values (1,'Mateo','M','labrador',2);

insert into Mascota values(5,'murcielago','F','Pomerania',3),(3,'Marco','M','Pastor Aleman',1);
insert into Vacuna values (4,'Pentavalenta','3','inmuniza contra el moquillo'),(5,'Hexavalenta','1','inmuniza contra el adenovirus 1');

insert into Cliente values (5926705,'Carlos','Mendoza','carrera 12',3203462980,1),(7226705,'Antonio','Gallego','carrera 10',3103562036,2),(10011299658,'Camila','Restrepo','calle 5',3124693194,1);

INSERT INTO Producto values (7,'cuerda','toys dog',10000,7226705),(8,'bozal','toys dog',20000,2147483647);
INSERT INTO Producto values (9,'Pelota','toys dog',2500,50705235),(10,'Placa','toys dog',15000,60725235),(11,'Cepillo','toys dog',20000,1501299658);
/*Consultar datos*/
select * from Cliente;
select * from mascota;
select * from Producto;
select nombreProducto AS 'Nombre',precio AS 'Valor' from Producto;
select nombreProducto AS 'Nombre',precio AS 'Valor' from Producto order by precio ASC;
select nombreProducto AS 'Nombre',precio AS 'Valor' from Producto where precio<15000;
select nombreProducto AS 'Nombre',precio AS 'Valor' from Producto where precio<=20000;
select nombreProducto AS 'Nombre',precio AS 'Valor' from Producto where precio<>10000;
select nombreProducto AS 'Nombre',precio AS 'Valor' from Producto where nombreProducto='hueso';
SELECT * from Vacuna order by dosisVacuna DESC;
select * from Producto where nombreProducto='cuerda' AND precio<15000;
select * from Producto where nombreProducto='cuerda' AND precio<15000;
select * from Producto where nombreProducto='cuerda' OR precio>35000;
select * from Producto where precio between 12000 and 21000;
select * from Mascota where nombreMascota LIKE 'murc%';
select * from Mascota where nombreMascota LIKE '%lu%';
select * from Mascota where nombreMascota LIKE '%lago';

select * from Mascota where nombreMascota not LIKE '%lago';
select * from Mascota where nombreMascota not LIKE 'M%';
select nombreProducto, marca, max(precio) from Producto;
select nombreProducto, marca, min(precio) from Producto;
select count(nombreProducto) from Producto;

SELECT SUM(cantidad) FROM Mascota;
select avg(precio) from Producto;
select * from Mascota group by generoMascota;

SELECT codigoProducto as Codigo, nombreProducto as Nombre, marca as marca, precio as precio, cedulaClienteFK as Cliente from Producto order by precio DESC;
SELECT * from Cliente order by apellidoCliente ASC;
SELECT * from Cliente order by nombreCliente ASC;
/*Modificar Update nombreTabla set campoaModificar='nuevovalor';*/
Update Mascota set nombreMascota='Rush' where idMascota= 2;
Update Mascota set generoMascota='M' where idMascota= 2;
Update Mascota set nombreMascota='Macarena' where idMascota<5;
Update Mascota set nombreMascota='Fridom' where idMascota between 1 and 2;
/*Eliminar datos*/
delete from Producto where codigoProducto=6;
delete from Cliente where cedulaCliente=5926705;
delete from Mascota where idMascota=3;

/*Consultas Multitabla*/
select m.*, c.nombreCliente
from Mascota m
left join cliente c on m.idMascota=c.idMascotaFK;

select m.*, c.nombreCliente
from Mascota m
Right join cliente c on m.idMascota=c.idMascotaFK group by m.nombreMascota;

select m.*, c.nombreCliente
from Mascota m
inner join cliente c on m.idMascota=c.idMascotaFK;

select m.*, c.nombreCliente, p.nombreProducto
from Mascota m
join cliente c on m.idMascota=c.idMascotaFK 
join producto p on p.cedulaClienteFK=c.cedulaCliente;

create view consultarMascota as
select idMascota,nombreMascota, generoMascota 
from Mascota;

select * from consultarMascota;

create view consultaClienteMascota as
select m.*, c.nombreCliente
from Mascota m
Right join cliente c on m.idMascota=c.idMascotaFK group by m.nombreMascota;

select * from consultaClienteMascota;

drop view consultarMascota;

/*Procedimientos almacenados*/
/*Insertar*/

Delimiter //
create procedure insertMascota(
idMascota int,
nombreMascota varchar (15),
generoMascota varchar (15),
razaMascota varchar (15),
cantidad int (10)
)
begin
insert into Mascota values(idMascota,nombreMascota,generoMascota,razaMascota,cantidad);
end //
Delimiter ;
drop procedure insertMascota;
call insertMascota(7,'Mar','F','bulldog',2);

Delimiter //
create procedure updateMascota(idMascota int,nombreMascota varchar (15),nuevonombre varchar(15),generoMascota varchar (15),nuevogenero varchar(15))
begin
Update Mascota set 
nombreMascota=nuevonombre where idMascota= idMascota;
end //
Delimiter ;

call updateMascota(1,'Fridom','maria','F','M');

set sql_safe_updates=1;

drop procedure updateMascota;

##subconsultas
/*consutas anidades subquery select  
(select co11,co12
from tabla_principal
where condicion);

escalar devuelve el unico valor o fila o la columna de fila devuelve una sola fila con varias 
columnas ROw()
de tabla devuelve varias filas y varias columnas correlacionadas */

create table departamentos (
    id int primary key,
    nombre_departamento varchar(50)
);

create table  empleados (
    id int primary key,
    nombre varchar(50),
    departamento_id int,
    salario decimal (10,2),
    foreign departamento_id) references  departamentos(id)
);
create table  productos (
    id int primary key,
    nombre varchar (50),
    precio decimal (10,2),
    categoria varchar(50)
);
insert into  departamentos (id, nombre_departamento) values 
(1, 'Ventas'),
(2, 'Tecnologia'),
(3, 'Recursos Humanos');

insert into  empleados (id, nombre, departamento_id, salario) values 
(1, 'Janier', 1, 2000000),
(2, 'Maria', 2, 3000000),
(3, 'Carlitos', 1, 2500000),
(4, 'Ana', 3, 2200000),
(5, 'Lucho', 2, 3500000);


insert into productos (id, nombre , precio, categoria) values 
(1, 'papa', 1, 23000000),
(2, 'yuca', 2, 3000000),
(3, 'platano', 1, 2500000),
(4, 'remolacha', 3, 2200000),
(5, 'sandia', 2, 3500000);



/* subconsultas*/
/* consultar los empleados*/
/*where*/
select nombre_empleado, salario_empleado
from  empleados
where  salario > 45000 and  salario < 3000000; 


/* consultar el salario de empleados */

select nombre_empleado, salario_empleado
from  empleados
where  depto_id in 
			( select id_depto
            from departamentos
            where nombre_depto in ('ventas', 'tegnologia' ));
            
            
            
            
/* voy a crear una tabla virtual  tablita derivada */
select depto_id, prom_salario
from  (select depto_id,avg(salario_empleado) as prom_salario
from empleados 
group by depto_id) as promedios 
where  prom_salario > 4500000

/* vamos a consultar cada empleado con el promedio general y cuanto se desvia su salario de ese promedio, donde me amuetra el nombre del empleado, 
salario que tiene , su promedio general de salario y cuanto se desvia la desviacion*/

select nombre,salario,
    (select  avg(salario) from empleados) as promedio_general,
    salario  (select avg(salario) from empleados) as desviacion
from  empleados;
