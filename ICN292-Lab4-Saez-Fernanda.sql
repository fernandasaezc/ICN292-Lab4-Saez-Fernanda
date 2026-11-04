DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

CREATE TABLE autores (
    id_autor INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60) NULL,
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL,
    PRIMARY KEY (id_autor)
);

CREATE TABLE colecciones (
    id_coleccion INT NOT NULL AUTO_INCREMENT,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL,
    PRIMARY KEY (id_coleccion)
);

CREATE TABLE libros (
    id_libro INT NOT NULL AUTO_INCREMENT,
    id_autor INT NOT NULL,
    id_coleccion INT NULL,
    titulo VARCHAR(120) NOT NULL,
    paginas INT,
    ejemplares_vendidos INT,
    anio INT,
    PRIMARY KEY (id_libro),
    CONSTRAINT fk_libros_autores
        FOREIGN KEY (id_autor) REFERENCES autores (id_autor),
    CONSTRAINT fk_libros_colecciones
        FOREIGN KEY (id_coleccion) REFERENCES colecciones (id_coleccion)
);
CREATE TABLE pagos (
    id_pago INT NOT NULL AUTO_INCREMENT,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pago),
    CONSTRAINT fk_pagos_autores
        FOREIGN KEY (id_autor) REFERENCES autores (id_autor)
);
INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');
INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio) VALUES
(1, 'Cielo de Enero', 210, 1500, 2024),
(1, 'Marea Baja', 185, 800, 2023),
(1, 'El Norte', 200, 2200, 2024),
(2, 'Estrellas que Caen', 240, 3000, 2022),
(2, 'Máquinas', 215, 450, 2024),
(3, 'Luz Artificial', 300, 1200, 2024),
(3, 'Ruido Blanco', 280, 600, 2023),
(4, 'El Barrio de Lila', 190, 5000, 2024),
(4, 'Antes del Amanecer', 205, 2700, 2024),
(4, 'La Calle 8', 175, 900, 2023),
(5, 'Flor de Hierro', 195, 4100, 2024),
(5, 'Hora Dorada', 220, 1800, 2022);

SELECT nombre, genero
FROM autores
WHERE pais <> 'Chile' OR pais IS NULL
ORDER BY nombre;

SELECT titulo, paginas
FROM libros
WHERE paginas BETWEEN 190 AND 220
ORDER BY paginas ASC;

SELECT COUNT(*) AS total_libros,
       SUM(ejemplares_vendidos) AS total_ejemplares,
       AVG(paginas) AS promedio_paginas,
       MIN(anio) AS anio_mas_antiguo,
       MAX(ejemplares_vendidos) AS max_ejemplares_libro
FROM libros;

SELECT DISTINCT genero
FROM autores
ORDER BY genero;

SELECT a.nombre, COUNT(*) AS libros_2024
FROM autores AS a
JOIN libros AS l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor, a.nombre
HAVING COUNT(*) > 1
ORDER BY a.nombre;

SELECT titulo, ejemplares_vendidos
FROM libros
WHERE anio = 2024 AND ejemplares_vendidos > 2000
ORDER BY ejemplares_vendidos DESC
LIMIT 3;

SET SQL_SAFE_UPDATES = 0;

INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio)
VALUES (3, 'Papel Mojado', 260, 50, 2024);

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

DELETE FROM libros WHERE titulo = 'Papel Mojado';

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

SELECT titulo, ejemplares_vendidos FROM libros WHERE titulo = 'Cielo de Enero';

UPDATE libros
SET ejemplares_vendidos = ejemplares_vendidos + 100
WHERE titulo = 'Cielo de Enero';

SELECT titulo, ejemplares_vendidos FROM libros WHERE titulo = 'Cielo de Enero';

SET SQL_SAFE_UPDATES = 1;

INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
('Voces del Sur', '2022-03-15'),
('Clásicos Modernos', '2023-06-01'),
('Lecturas de Temporada', '2024-01-20');

UPDATE libros SET id_coleccion = 1 WHERE id_libro BETWEEN 1 AND 5;
UPDATE libros SET id_coleccion = 2 WHERE id_libro BETWEEN 6 AND 10;
UPDATE libros SET id_coleccion = 3 WHERE id_libro BETWEEN 11 AND 12;

SELECT l.titulo AS libro,
       c.titulo AS coleccion,
       c.fecha_publicacion
FROM libros AS l
JOIN colecciones AS c ON l.id_coleccion = c.id_coleccion
ORDER BY c.fecha_publicacion, l.titulo;

INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
(1, '2024-02-15', 350000.50),
(1, '2024-08-20', 120000.00),
(4, '2024-05-05', 800000.00),
(4, '2024-11-12', 275000.75),
(5, '2024-06-30', 150000.00),
(2, '2024-09-18', 90000.00);

SELECT a.nombre, p.fecha_pago, p.monto
FROM pagos AS p
JOIN autores AS a ON p.id_autor = a.id_autor
ORDER BY a.nombre, p.fecha_pago;

SELECT a.nombre, SUM(p.monto) AS total_pagado
FROM pagos AS p
JOIN autores AS a ON p.id_autor = a.id_autor
GROUP BY a.id_autor, a.nombre
ORDER BY a.nombre;