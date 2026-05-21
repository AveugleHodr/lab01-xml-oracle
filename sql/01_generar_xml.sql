-- ============================================================
-- Laboratorio #1: Almacenamiento y validacion de ficheros XML
-- Archivo: 01_generar_xml.sql
-- Descripcion: Genera XML desde el esquema HR usando SQL/XML
--              Combina las tablas EMPLOYEES, DEPARTMENTS y LOCATIONS
-- ============================================================

-- Conectarse con el usuario HR:
-- CONNECT hr/hr@localhost:1521/ORCL

-- ----------------------------------------------------------------
-- CONSULTA PRINCIPAL: Genera el documento XML completo
-- JOIN entre EMPLOYEES, DEPARTMENTS y LOCATIONS (3 tablas)
-- ----------------------------------------------------------------
SELECT
    XMLELEMENT(
        "empleados",
        XMLAGG(
            XMLELEMENT(
                "empleado",
                XMLATTRIBUTES(e.employee_id AS "id"),
                XMLFOREST(
                    e.first_name          AS "nombre",
                    e.last_name           AS "apellido",
                    e.email               AS "email",
                    e.phone_number        AS "telefono",
                    e.hire_date           AS "fecha_contratacion",
                    e.salary              AS "salario"
                ),
                XMLELEMENT(
                    "departamento",
                    XMLATTRIBUTES(d.department_id AS "id"),
                    XMLFOREST(
                        d.department_name AS "nombre_departamento",
                        l.city            AS "ciudad"
                    )
                )
            )
            ORDER BY e.employee_id
        )
    ).getClobVal() AS xml_resultado
FROM hr.employees   e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.locations   l ON d.location_id   = l.location_id
WHERE e.employee_id IN (100,101,102,103,107,114,120,145,201,205);

-- ----------------------------------------------------------------
-- CONSULTA ALTERNATIVA: Solo EMPLOYEES + DEPARTMENTS (2 tablas)
-- Util si no se tiene acceso a LOCATIONS
-- ----------------------------------------------------------------
SELECT
    XMLELEMENT(
        "empleados",
        XMLAGG(
            XMLELEMENT(
                "empleado",
                XMLATTRIBUTES(e.employee_id AS "id"),
                XMLFOREST(
                    e.first_name AS "nombre",
                    e.last_name  AS "apellido",
                    e.email      AS "email",
                    e.salary     AS "salario"
                ),
                XMLELEMENT(
                    "departamento",
                    XMLATTRIBUTES(d.department_id AS "id"),
                    XMLFOREST(
                        d.department_name AS "nombre_departamento"
                    )
                )
            )
            ORDER BY e.employee_id
        )
    ).getClobVal() AS xml_resultado
FROM hr.employees   e
JOIN hr.departments d ON e.department_id = d.department_id;
