# Laboratorio 1 - XML en Oracle

Laboratorio 1 de Bases de Datos Avanzadas - UNIR
Alumno: Juan Sebastian Corso
Mayo 2026

## De que trata

Para este lab tuve que crear un archivo XML con datos del esquema HR de Oracle (empleados y departamentos), validarlo con un XSD y despues hacer consultas con XQuery en eXist-db.

## Archivos

```
sql/
  01_generar_xml.sql        -> consulta para sacar los datos en formato XML
  02_registrar_esquema.sql  -> registra el XSD en oracle
  03_insercion_validacion.sql -> prueba insertar datos validos e invalidos

xml/
  hr_empleados.xml  -> el xml con los datos de empleados
  hr_esquema.xsd    -> el esquema para validar el xml

xquery/
  consultas.xq  -> consultas que hice en eXist-db
```

## Como correrlo

Para las consultas SQL use Oracle LiveSQL (livesql.oracle.com) porque no tenia oracle instalado localmente. Hay que seleccionar el schema HR y ejecutar los archivos de la carpeta sql/ en orden.

Para eXist-db:
- prender el servidor
- subir hr_empleados.xml a /db/hr/ desde eXide
- copiar las consultas del archivo consultas.xq y ejecutarlas con Eval

## El XML

Saque datos de las tablas EMPLOYEES, DEPARTMENTS y LOCATIONS con un JOIN. El resultado es algo asi:

```xml
<empleados>
  <empleado id="100">
    <nombre>Steven</nombre>
    <apellido>King</apellido>
    <salario>24000</salario>
    <departamento id="90">
      <nombre_departamento>Executive</nombre_departamento>
      <ciudad>Seattle</ciudad>
    </departamento>
  </empleado>
</empleados>
```

## Validacion

Valide el xml en xmlvalidation.com pegando el xml y el xsd. Salio que no habia errores.

El XSD tiene una restriccion de que el salario tiene que estar entre 1000 y 40000, entonces probe insertar un empleado con salario 999999 y Oracle lo rechazo con error.

## Herramientas que use

- VS Code
- Oracle LiveSQL
- xmlvalidation.com
- eXist-db
