-- ============================================================
-- Laboratorio #1: Almacenamiento y validacion de ficheros XML
-- Archivo: 02_registrar_esquema.sql
-- Descripcion: Registra el esquema XSD en Oracle y crea la tabla
--              con columna XMLType validada contra dicho esquema
-- ============================================================

-- ----------------------------------------------------------------
-- PASO 1: Registrar el esquema XSD en Oracle XML DB
-- Debe ejecutarse como usuario HR o con permisos suficientes
-- ----------------------------------------------------------------
BEGIN
    DBMS_XMLSCHEMA.registerSchema(
        schemaURL   => 'http://localhost/hr_esquema.xsd',
        schemaDoc   => bfilename('XMLDIR', 'hr_esquema.xsd'),
        local       => TRUE,
        genTypes    => TRUE,
        genTables   => FALSE
    );
END;
/

-- Alternativa: registrar el XSD directamente como cadena de texto
BEGIN
    DBMS_XMLSCHEMA.registerSchema(
        schemaURL => 'http://localhost/hr_esquema.xsd',
        schemaDoc =>
'<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema"
           elementFormDefault="qualified">
  <xs:element name="empleados">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="empleado" type="tipoEmpleado"
                    minOccurs="1" maxOccurs="unbounded"/>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
  <xs:complexType name="tipoEmpleado">
    <xs:sequence>
      <xs:element name="nombre"             type="xs:string"/>
      <xs:element name="apellido"           type="xs:string"/>
      <xs:element name="email"              type="xs:string"/>
      <xs:element name="telefono"           type="xs:string"/>
      <xs:element name="fecha_contratacion" type="xs:date"/>
      <xs:element name="salario"            type="tipoSalario"/>
      <xs:element name="departamento"       type="tipoDepartamento"/>
    </xs:sequence>
    <xs:attribute name="id" type="xs:positiveInteger" use="required"/>
  </xs:complexType>
  <xs:simpleType name="tipoSalario">
    <xs:restriction base="xs:decimal">
      <xs:minInclusive value="1000"/>
      <xs:maxInclusive value="40000"/>
    </xs:restriction>
  </xs:simpleType>
  <xs:complexType name="tipoDepartamento">
    <xs:sequence>
      <xs:element name="nombre_departamento" type="xs:string"/>
      <xs:element name="ciudad"              type="xs:string"/>
    </xs:sequence>
    <xs:attribute name="id" type="xs:positiveInteger" use="required"/>
  </xs:complexType>
</xs:schema>',
        local     => TRUE,
        genTypes  => TRUE,
        genTables => FALSE
    );
END;
/

-- ----------------------------------------------------------------
-- PASO 2: Crear tabla con columna XMLType validada por el esquema
-- ----------------------------------------------------------------
CREATE TABLE hr_empleados_xml (
    id          NUMBER         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    descripcion VARCHAR2(200),
    datos_xml   XMLTYPE
)
XMLTYPE COLUMN datos_xml
XMLSCHEMA "http://localhost/hr_esquema.xsd"
ELEMENT "empleados";

-- ----------------------------------------------------------------
-- PASO 3: Verificar que el esquema fue registrado
-- ----------------------------------------------------------------
SELECT schema_url, local
FROM   user_xml_schemas;
