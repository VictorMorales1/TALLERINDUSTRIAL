

select * from usuario

select * from PRODUCTO

select * from rol

select * from CLIENTE
select * from PROVEEDOR	

select IdCategoria,Descripcion,Estado from CATEGORIA

select IdProducto,Codigo,Nombre,p.Descripcion,c.IdCategoria,c.Descripcion[DescripcionCategoria],Stock,PrecioCompra,PrecioVenta,p.Estado from PRODUCTO p
inner join CATEGORIA c on c.IdCategoria = p.IdCategoria

select u.IdUsuario,u.Documento,u.NombreCompleto,u.Correo,u.Clave,u.Estado,r.IdRol,r.Descripcion from usuario u
inner join rol r on r.IdRol = u.IdRol

select IdProveedor,Documento,RazonSocial,Correo,Telefono,Estado from PROVEEDOR

insert into PRODUCTO (Codigo,Nombre,descripcion,IdCategoria) values('123456','omo pvo limon','15x700gr',3)		
update PRODUCTO set Estado = 1

select IdCliente,Documento,NombreCompleto,Correo,Telefono,Estado from CLIENTE

select * from CATEGORIA

insert into CATEGORIA(Descripcion,Estado) values('OMO DETERGENTE 700GR' ,1)
insert into CATEGORIA(Descripcion,Estado) values('OMO DETERGENTE 150GR' ,1)
insert into CATEGORIA(Descripcion,Estado) values('OMO DETERGENTE 1000GR' ,1)

insert into rol (Descripcion)
values('VENDEDOR')


/*
insert into rol (Descripcion)
values('ADMINISTRADOR')

insert into rol (Descripcion)
values('JEFE DE ALMACEN')

insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)
values

('12488437','ADMIN','victormauriciomoraleslopez7@gmail.com','123',1,1)

insert into USUARIO(Documento,NombreCompleto,Correo,Clave,IdRol,Estado)
values

('1234567','JEFE DE ALMACEN','jefedealmacen@gmail.com','123',2,1)
*/
select * from rol
/*
select p.IdRol,p.NombreMenu from PERMISO p
inner join ROL r on r.IdRol = p.IdRol
inner join USUARIO u on u.IdRol = r.IdRol

where u.IdUsuario = 1


insert into PERMISO(IdRol,NombreMenu) values
(1,'menuusuario'),
(1,'menustock'),
(1,'menuventas'),
(1,'menucompras'),
(1,'menuclientes'),
(1,'menuproveedores'),
(1,'menureportes'),
(1,'menuacercade')

insert into PERMISO(IdRol,NombreMenu) values
(2,'menustock'),
(2,'menucompras'),
(2,'menuproveedores'),
(2,'menureportes')
*/
insert into PERMISO(IdRol,NombreMenu) values
(3,'menuclientes'),
(3,'menuventas'),
(3,'menureportes')


select * from COMPRA where NumeroDocumento ='00001'
select * from DETALLE_COMPRA where IdCompra = 1

select c.IdCompra,
u.NombreCompleto,
pr.Documento, pr.RazonSocial,
c.TipoDocumento, c.NumeroDocumento,c.MontoTotal,convert(char(10),c.FechaRegistro,103)[FechaRegistro]
from COMPRA c
inner join USUARIO u on u.IdUsuario = c.IdUsuario
inner join PROVEEDOR pr on pr.IdProveedor = c.IdProveedor
where c.NumeroDocumento = '00001'

select p.Nombre,dc.PrecioCompra,dc.Cantidad,dc.MontoTotal
from DETALLE_COMPRA dc
inner join PRODUCTO p on p.IdProducto = dc.IdProducto
where dc.IdCompra = 1