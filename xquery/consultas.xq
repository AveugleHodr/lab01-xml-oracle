(: ============================================================
   Laboratorio #1 - Consultas XQuery / XPath para eXist-db
   Archivo: consultas.xq
   Base de datos: hr_empleados.xml (cargado en eXist-db)
   ============================================================ :)

(: ----------------------------------------------------------------
   CONFIGURACION EN eXist-db:
   1. Abrir eXist-db (http://localhost:8080/exist)
   2. Ir a eXide (editor XML)
   3. Subir hr_empleados.xml a /db/hr/hr_empleados.xml
   4. Ejecutar cada consulta en la pestana XQuery
   ---------------------------------------------------------------- :)

(: ----------------------------------------------------------------
   CONSULTA 1 - XPath basico: Listar nombres de todos los empleados
   Resultado: lista de strings con nombres
   ---------------------------------------------------------------- :)
for $emp in doc("/db/hr/hr_empleados.xml")//empleado
return $emp/nombre/text()


(: ----------------------------------------------------------------
   CONSULTA 2 - XPath con predicado: Empleados con salario > 10000
   Equivalente al JOIN EMPLOYEES + DEPARTMENTS con WHERE salary>10000
   ---------------------------------------------------------------- :)
for $emp in doc("/db/hr/hr_empleados.xml")//empleado
where xs:decimal($emp/salario) > 10000
order by xs:decimal($emp/salario) descending
return
  <resultado>
    <nombre>{$emp/nombre/text()} {$emp/apellido/text()}</nombre>
    <salario>{$emp/salario/text()}</salario>
    <departamento>{$emp/departamento/nombre_departamento/text()}</departamento>
  </resultado>


(: ----------------------------------------------------------------
   CONSULTA 3 - JOIN simulado: Empleados agrupados por departamento
   Combina datos de empleado y departamento (dos "tablas" en XML)
   ---------------------------------------------------------------- :)
for $dept in distinct-values(
    doc("/db/hr/hr_empleados.xml")//departamento/nombre_departamento
)
let $empleados := doc("/db/hr/hr_empleados.xml")//empleado[
    departamento/nombre_departamento = $dept
]
order by $dept
return
  <departamento nombre="{$dept}" total="{count($empleados)}">
    {
      for $e in $empleados
      return
        <empleado id="{$e/@id}">
          <nombre>{$e/nombre/text()} {$e/apellido/text()}</nombre>
          <salario>{$e/salario/text()}</salario>
        </empleado>
    }
  </departamento>


(: ----------------------------------------------------------------
   CONSULTA 4 - Estadisticas: Salario promedio por departamento
   Equivale a: SELECT dept, AVG(salary) FROM emp JOIN dept GROUP BY dept
   ---------------------------------------------------------------- :)
for $dept in distinct-values(
    doc("/db/hr/hr_empleados.xml")//departamento/nombre_departamento
)
let $salarios := doc("/db/hr/hr_empleados.xml")//empleado[
    departamento/nombre_departamento = $dept
]/salario
return
  <estadistica>
    <departamento>{$dept}</departamento>
    <promedio_salario>{
      format-number(avg($salarios/xs:decimal(.)), "0.00")
    }</promedio_salario>
    <num_empleados>{count($salarios)}</num_empleados>
  </estadistica>


(: ----------------------------------------------------------------
   CONSULTA 5 - Busqueda por ciudad: Empleados en Seattle
   Demuestra navegacion multi-nivel en el XML
   ---------------------------------------------------------------- :)
doc("/db/hr/hr_empleados.xml")//empleado[
    departamento/ciudad = "Seattle"
]
