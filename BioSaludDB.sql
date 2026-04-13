-- 1. Crear la base de datos
CREATE DATABASE BIOSalud;
GO
USE BIOSalud;
GO

CREATE TABLE Rol (
    id_rol INT PRIMARY KEY IDENTITY(1,1),
    nombre_rol NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255)
);

CREATE TABLE Estado_Asistencia (
    id_estado INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL -- Ej: 'Inscrito', 'Asistió', 'Canceló'
);

CREATE TABLE Categoria (
    id_categoria INT PRIMARY KEY IDENTITY(1,1),
    nombre_categoria NVARCHAR(100) NOT NULL,
    descripcion NVARCHAR(MAX)
);

CREATE TABLE Grupo_de_Apoyo (
    id_grupo INT PRIMARY KEY IDENTITY(1,1),
    nombre_grupo NVARCHAR(100) NOT NULL,
    tematica NVARCHAR(100),
    fecha_creacion DATE DEFAULT GETDATE()
);

-- =============================================
-- SECCIÓN: TABLAS PRINCIPALES
-- =============================================

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    correo_electronico NVARCHAR(100) UNIQUE NOT NULL,
    contraseña NVARCHAR(255) NOT NULL,
    fecha_registro DATE DEFAULT GETDATE(),
    foto_perfil NVARCHAR(255),
    biografía NVARCHAR(MAX),
    id_rol INT,
    CONSTRAINT FK_Usuario_Rol FOREIGN KEY (id_rol) REFERENCES Rol(id_rol)
);

CREATE TABLE Reunion (
    id_reunion INT PRIMARY KEY IDENTITY(1,1),
    titulo NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(MAX),
    fecha_hora DATETIME NOT NULL,
    ubicacion NVARCHAR(255),
    capacidad_maxima INT,
    id_administrador INT, -- FK a Usuario
    id_categoria INT,
    id_grupo INT,
    CONSTRAINT FK_Reunion_Admin FOREIGN KEY (id_administrador) REFERENCES Usuario(id_usuario),
    CONSTRAINT FK_Reunion_Categoria FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    CONSTRAINT FK_Reunion_Grupo FOREIGN KEY (id_grupo) REFERENCES Grupo_de_Apoyo(id_grupo)
);

-- =============================================
-- SECCIÓN: TABLAS DE INTERACCIÓN
-- =============================================

CREATE TABLE Asistencia_Usuario_Reunion (
    id_asistencia INT PRIMARY KEY IDENTITY(1,1),
    id_usuario INT,
    id_reunion INT,
    id_estado INT,
    CONSTRAINT FK_Asistencia_Usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT FK_Asistencia_Reunion FOREIGN KEY (id_reunion) REFERENCES Reunion(id_reunion),
    CONSTRAINT FK_Asistencia_Estado FOREIGN KEY (id_estado) REFERENCES Estado_Asistencia(id_estado)
);

CREATE TABLE Comentario (
    id_comentario INT PRIMARY KEY IDENTITY(1,1),
    contenido NVARCHAR(MAX) NOT NULL,
    calificacion INT CHECK (calificacion BETWEEN 1 AND 5),
    fecha DATE DEFAULT GETDATE(),
    id_usuario INT,
    id_reunion INT,
    CONSTRAINT FK_Comentario_Usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
    CONSTRAINT FK_Comentario_Reunion FOREIGN KEY (id_reunion) REFERENCES Reunion(id_reunion)
);

CREATE TABLE Notificacion (
    id_notificacion INT PRIMARY KEY IDENTITY(1,1),
    mensaje NVARCHAR(255) NOT NULL,
    leido BIT DEFAULT 0, -- 0 = No leído, 1 = Leído
    fecha_envio DATETIME DEFAULT GETDATE(),
    id_usuario INT,
    CONSTRAINT FK_Notificacion_Usuario FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);
GO