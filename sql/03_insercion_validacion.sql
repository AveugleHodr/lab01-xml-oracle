-- ============================================================
-- Laboratorio #1: Almacenamiento y validacion de ficheros XML
-- Archivo: 03_insercion_validacion.sql
-- Descripcion: Inserciones validas e invalidas para comprobar
--              la validacion del esquema XSD en Oracle
-- ============================================================

-- ----------------------------------------------------------------
-- INSERCION VALIDA
-- Cumple todas las restricciones del esquema XSD:
--   - salario entre 1000 y 40000
--   - fecha en formato xs:date (YYYY-MM-DD)
--   - todos los elementos obligatorios presentes
--   - atributo "id" positivo
-- ----------------------------------------------------------------
INSERT INTO hr_empleados_xml (descripcion, datos_xml)
VALUES (
    'Insercion valida - empleado correcto',
    XMLTYPE('<?xml version="1.0" encoding="UTF-8"?>
<empleados>
  <empleado id="999">
    <nombre>Sebastian</nombre>
    <apellido>Corso</apellido>
    <email>SCORSO</email>
    <telefono>310.555.0199</telefono>
    <fecha_contratacion>2024-01-15</fecha_contratacion>
    <salario>5500</salario>
    <departamento id="60">
      <nombre_departamento>IT</nombre_departamento>
      <ciudad>Bogota</ciudad>
    </departamento>
  </empleado>
</empleados>')
);

COMMIT;
-- Resultado esperado: 1 row inserted

-- ----------------------------------------------------------------
-- VERIFICAR LA INSERCION VALIDA
-- ----------------------------------------------------------------
SELECT id, descripcion,
       datos_xml.extract('//empleado/@id').getStringVal()    AS emp_id,
       datos_xml.extract('//nombre/text()').getStringVal()   AS nombre,
       datos_xml.extract('//salario/text()').getStringVal()  AS salario
FROM   hr_empleados_xml;

-- ----------------------------------------------------------------
-- INSERCION INVALIDA #1: salario fuera del rango (>40000)
-- El esquema XSD restringe el salario a max 40000
-- Oracle debe lanzar ORA-31154 o similar al validar el esquema
-- ----------------------------------------------------------------
INSERT INTO hr_empleados_xml (descripcion, datos_xml)
VALUES (
    'Insercion invalida - salario fuera de rango',
    XMLTYPE('<?xml version="1.0" encoding="UTF-8"?>
<empleados>
  <empleado id="998">
    <nombre>Error</nombre>
    <apellido>Invalido</apellido>
    <email>EINVALID</email>
    <telefono>000.000.0000</telefono>
    <fecha_contratacion>2024-01-15</fecha_contratacion>
    <salario>999999</salario>
    <departamento id="10">
      <nombre_departamento>Administration</nombre_departamento>
      <ciudad>Seattle</ciudad>
    </departamento>
  </empleado>
</empleados>')
);
-- Resultado esperado: ERROR - ORA-31154: invalid XML document
--                     o XMLSchema validation error

-- ----------------------------------------------------------------
-- INSERCION INVALIDA #2: falta el elemento obligatorio <email>
-- El esquema XSD exige que <email> este presente en la secuencia
-- ----------------------------------------------------------------
INSERT INTO hr_empleados_xml (descripcion, datos_xml)
VALUES (
    'Insercion invalida - falta elemento email',
    XMLTYPE('<?xml version="1.0" encoding="UTF-8"?>
<empleados>
  <empleado id="997">
    <nombre>Sin</nombre>
    <apellido>Email</apellido>
    <telefono>111.222.3333</telefono>
    <fecha_contratacion>2024-03-01</fecha_contratacion>
    <salario>3000</salario>
    <departamento id="20">
      <nombre_departamento>Marketing</nombre_departamento>
      <ciudad>Toronto</ciudad>
    </departamento>
  </empleado>
</empleados>')
);
-- Resultado esperado: ERROR - elemento requerido <email> ausente

-- ----------------------------------------------------------------
-- CONSULTA FINAL: Verificar estado de la tabla
-- Solo debe existir el registro de la insercion valida
-- ----------------------------------------------------------------
SELECT id, descripcion FROM hr_empleados_xml;
