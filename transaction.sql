use master
go

drop database empresa
go

create database empresa
go
use empresa
go

create table depto(
	id int not null identity (0,1),
	dsName varchar(250)	
	
	primary key(id)
)

create table func(
	id int not null identity (0,1),
	nome varchar(250),
	cargo varchar (250),
	
	primary key(id)
)

create table equipe(
	id int not null identity(0,1),
	nome varchar (250),
	area varchar(250)
	
	primary key(id) 
)
create table relEquiepeDepto(
	id int not null identity(0,1),
	idEquipe int not null,
	idDepto int not null,
	
	PRIMARY KEY(id),
	FOREIGN KEY (idEquipe) references equipe(id),
	FOREIGN KEY (idDepto) references depto(id)
)

create table relEquipeFunc(
	id int not null identity(0,1),
	idEquipe int not null, 
	idFunc int not null,
	
	PRIMARY KEY(id),
	FOREIGN KEY (idEquipe) references equipe(id),
	FOREIGN KEY (idFunc) references func(id)
)

-- Transaction 2
begin transaction
    insert into equipe (nome, area) values ('preto','marketing')
	insert into depto (dsName) values ('marketing')
	insert into relEquiepeDepto (idDepto, idEquipe) values (0,0)	
commit
go
-- Transaction 2
begin transaction
	insert into func(nome, cargo) values('luis','chefe de depto')
	insert into relEquipeFunc(idEquipe, idFunc) values (0,0)
commit
go

-- trigger para assegurar integridade dos dados inseridos na tabela RelEquipeDeto

CREATE TRIGGER AuditDPTO
ON relEquiepeDepto
FOR INSERT
AS
	DECLARE @idDPT int,@idEqp int 
	select @idDPT = idDepto from inserted
	SELECT @idEqp = idEquipe from inserted
	if NOT EXISTS(SELECT * FROM equipe where id = @idEqp) and NOT EXISTS(SELECT * FROM depto where id = @idDPT)
		BEGIN
			print N'deu errado'
			ROLLBACK
		END
	ELSE
		BEGIN
			print N'deu certo'
			commit
		END
GO

select * from depto	
select * from relEquiepeDepto
select * from relEquipeFunc

