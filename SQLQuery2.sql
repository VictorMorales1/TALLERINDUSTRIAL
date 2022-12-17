select * from USUARIO

CREATE PROC SP_REGISTRARUSUARIO(
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@IdUsuarioResultado int output,
@Mensaje varchar(500) output
)
as
begin
	set @IdUsuarioResultado = 0
	set @Mensaje = ''
	if not exists(select * from USUARIO where Documento = @Documento)
	begin
		insert into usuario(Documento,NombreCompleto,Correo,CLave,IdRol,Estado) values
		(@Documento,@NombreCompleto,@Correo,@Clave,@IdRol,@Estado)

		set @IdUsuarioResultado = SCOPE_IDENTITY()
		

	end
	else
		set @Mensaje = 'No se puede repetir el documento'
end



go


CREATE PROC SP_EDITARUSUARIO(
@IdUsuario int,
@Documento varchar(50),
@NombreCompleto varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@IdRol int,
@Estado bit,
@Respuesta bit output,
@Mensaje varchar(500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	if not exists(select * from USUARIO where Documento = @Documento and idusuario != @IdUsuario)
	begin
		update usuario set 
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		CLave = @Clave,
		IdRol = @IdRol,
		Estado = @Estado
		where IdUsuario = @IdUsuario
		

		set @Respuesta = 1
		

	end
	else
		set @Mensaje = 'No se puede repetir el documento'
end

go

CREATE PROC SP_ELIMINARUSUARIO(
@IdUsuario int,
@Respuesta bit output,
@Mensaje varchar(500) output
)
as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1

	IF EXISTS (SELECT * FROM COMPRA C
	INNER JOIN USUARIO U ON U.IdUsuario = C.IdUsuario
	WHERE U.IDUSUARIO = @IdUsuario
	)
	BEGIN

	set @pasoreglas = 0
	set @Respuesta = 0
	set @Mensaje = 'NO se puede eliminar, el usuario tiene relacion con una compra\n'
	END

	IF EXISTS (SELECT * FROM VENTA V
	INNER JOIN USUARIO U ON U.IdUsuario = V.IdUsuario
	WHERE U.IDUSUARIO = @IdUsuario
	)
	BEGIN

	set @pasoreglas = 0
	set @Respuesta = 0
	set @Mensaje = 'NO se puede eliminar, el usuario tiene relacion con una venta\n'
	END

	if (@pasoreglas = 1)
	begin 
		delete from USUARIO where IdUsuario = @IdUsuario
		set @Respuesta = 1
	end


end




go

/*categorias*/

CREATE PROC SP_RegistrarCategoria(
@Descripcion varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin 
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
	begin
		insert into CATEGORIA(Descripcion,Estado) values (@Descripcion,@Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'No se puede repetir la Descripcion'
end

go

CREATE procedure sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(50),
@Estado bit,	
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin 
	SET @Resultado = 1
	IF not exists (SELECT * FROM CATEGORIA where Descripcion =@Descripcion and IdCategoria != @IdCategoria)
	
	update CATEGORIA set
	Descripcion = @Descripcion,
	Estado = @Estado
	where IdCategoria = @IdCategoria
	
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'No se puede repetir la Descripcion'
	end
end


go

create procedure sp_EliminarCategoria(
@IdCategoria int,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin 
	SET @Resultado = 1
	IF not exists (
	SELECT * FROM CATEGORIA c
	inner join PRODUCTO p on p.IdCategoria = c.IdCategoria
	where c.IdCategoria = @IdCategoria)
	begin
	delete top(1) from CATEGORIA where IdCategoria = @IdCategoria
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'La categoria esta relacionada a un producto'
	end
end

go
/*PRODUCTOS*/

select * from PRODUCTO

create PROC SP_RegistrarProductos(

@Codigo varchar (20),
@Nombre varchar(30),
@Descripcion varchar(50),
@IdCategoria int,
@Estado bit,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin 
	set @Resultado = 0
	if not exists (select * from producto where Codigo = @Codigo)
	begin
		insert into producto(Codigo,Nombre,Descripcion,IdCategoria,Estado) values(@Codigo,@Nombre,@Descripcion,@IdCategoria,@Estado)
		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'Ya existe un producto con el mismo codigo'
end


go

create PROC SP_ModificarProductos(
@IdProducto int,
@Codigo varchar (20),
@Nombre varchar(30),
@Descripcion varchar(50),
@IdCategoria int,
@Estado bit,
@Resultado bit output,
@Mensaje varchar(500) output
)as
begin 
	set @Resultado = 1
	if not exists (select * from producto where Codigo = @Codigo and IdProducto != @IdProducto)
		
		UPDATE PRODUCTO SET
		codigo = @Codigo,
		Nombre = @Nombre,
		Descripcion = @Descripcion,
		IdCategoria = @IdCategoria,
		Estado = @Estado
		where IdProducto = @IdProducto
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'Ya existe un producto con el mismo codigo'
	end		
end

go	


CREATE PROC SP_ElimiarProductos(
@IdProducto int,
@Respuesta bit output,
@Mensaje varchar(500) output
)as
begin
	set @Respuesta = 0
	set @Mensaje = ''
	declare @pasoreglas bit = 1
	if exists (select * from DETALLE_COMPRA dc
	inner join PRODUCTO p on p.IdProducto = dc.IdProducto
	where p.IdProducto = @IdProducto
		)
	begin 
		set @pasoreglas = 0
		set @Respuesta = 0 
		set @Mensaje = @Mensaje + 'No se puede eliminar porque tiene relacion con una compra\n'
	end
	if exists (select * from DETALLE_VENTA dv
	inner join PRODUCTO p on p.IdProducto = dv.IdProducto
	where p.IdProducto = @IdProducto
		)
	begin 
		set @pasoreglas = 0
		set @Respuesta = 0 
		set @Mensaje = @Mensaje + 'No se puede eliminar porque tiene relacion con una vent\n'
	end		

	if(@pasoreglas = 1)
	begin
		delete from PRODUCTO where IdProducto = @IdProducto
		set @Respuesta = 1
	end
end




go
/*clientes*/

create proc SP_RegistrarCliente(
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin 
	set @Resultado = 0
	declare @IDPERSONA int
	if not exists (select * from CLIENTE where Documento = @Documento)
	begin
		insert into CLIENTE (Documento,NombreCompleto,Correo,Telefono,Estado) values (@Documento,@NombreCompleto,@Correo,
		@Telefono,@Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El numero de documento ya existe'
end

go

create proc SP_ModificarCliente(
@IdCliente int,
@Documento varchar(50),
@NombreCompleto varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin 
	set @Resultado = 1
	declare @IDPERSONA int
	if not exists (select * from CLIENTE where Documento = @Documento and IdCliente != @IdCliente)
	begin
		update CLIENTE set
		Documento = @Documento,
		NombreCompleto = @NombreCompleto,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdCliente = @IdCliente
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'El numero de documento ya existe'
	end
end
GO
/*proveedores*/


create proc SP_RegistrarProveedor(
@Documento varchar(50),
@RazonSocial varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin 
	set @Resultado = 0
	declare @IDPERSONA int
	if not exists (select * from PROVEEDOR where Documento = @Documento)
	begin
		insert into PROVEEDOR(Documento,RazonSocial,Correo,Telefono,Estado) values (@Documento,@RazonSocial,@Correo,
		@Telefono,@Estado)

		set @Resultado = SCOPE_IDENTITY()
	end
	else
		set @Mensaje = 'El numero de documento ya existe'
end
go

create proc SP_ModificarProveedor(
@IdProveedor int,
@Documento varchar(50),
@RazonSocial varchar(50),
@Correo varchar(50),
@Telefono varchar(50),
@Estado bit,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin 
	set @Resultado = 1
	declare @IDPERSONA int
	if not exists (select * from PROVEEDOR where Documento = @Documento and IdProveedor != @IdProveedor)
	begin
		update PROVEEDOR set
		Documento = @Documento,
		RazonSocial = @RazonSocial,
		Correo = @Correo,
		Telefono = @Telefono,
		Estado = @Estado
		where IdProveedor = @IdProveedor
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'El numero de documento ya existe'
	end
end

go

create proc SP_EliminarProveedor(
@IdProveedor int,
@Resultado int output,
@Mensaje varchar(500) output
)as
begin 
	set @Resultado = 1
	if not exists (select * from PROVEEDOR p inner join COMPRA c on p.IdProveedor = c.IdProveedor
	where p.IdProveedor = @IdProveedor
	)
	begin
		delete top(1) from PROVEEDOR where IdProveedor = @IdProveedor
	end
	else
	begin
		set @Resultado = 0
		set @Mensaje = 'El proveedor esta relacionado a una compra'
	end
end

go

/*proceso para registrar una compra*/

CREATE TYPE [dbo].[EDetalle_Compra]as table(
	[IdProducto] int null,
	[PrecioCompra] decimal(18,2) null,
	[PrecioVenta] decimal(18,2) null,
	[Cantidad] int null,
	[MontoTotal] decimal(18,2) null
	)

go

select count(*) + 1 from COMPRA


create procedure SP_RegistrarCompra(
@IdUsuario int,
@IdProveedor int,
@TipoDocumento varchar(500),
@NumeroDocumento varchar(500),
@MontoTotal decimal(18,2),
@DetalleCompra [EDetalle_Compra] readonly,
@Resultado bit output,
@Mensaje varchar(500) output
)
as
begin

	begin try
		declare @idcompra int = 0
		set @Resultado = 1
		set @Mensaje=''

		begin transaction registro
			insert into COMPRA(IdUsuario,IdProveedor,TipoDocumento,NumeroDocumento,MontoTotal)
			values (@IdUsuario,@IdProveedor,@TipoDocumento,@NumeroDocumento,@MontoTotal)

			set @idcompra = SCOPE_IDENTITY()	
			insert into DETALLE_COMPRA(IdCompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal)
			select @idcompra,IdProducto,PrecioCompra,PrecioVenta,Cantidad,MontoTotal from @DetalleCompra

			update p set p.Stock = p.Stock + dc.Cantidad,
			p.PrecioCompra = dc.PrecioCompra,
			p.PrecioVenta = dc.PrecioVenta
			from PRODUCTO p
			inner join @DetalleCompra dc on dc.IdProducto = p.IdProducto
		commit transaction registro
			
	end try
	begin catch

		set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
	end catch
end

go

