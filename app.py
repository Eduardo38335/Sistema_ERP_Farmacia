from flask import Flask, render_template, request, redirect, url_for
import mysql.connector

# IMPORTAMOS LA CONFIGURACIÓN (NUEVO)
from config import DB_CONFIG

app = Flask(__name__)



# 1. INICIO
@app.route('/')
def inicio():
    return render_template('index.html')

# 2. VER INVENTARIO
@app.route('/inventario')
def inventario():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    query = """
        SELECT 
            p.sku, 
            p.upc, 
            p.nombre, 
            p.descripcion, 
            c.nombre as categoria, 
            IFNULL(SUM(l.stock_actual), 0) as total_stock, 
            p.precio_venta
        FROM productos p
        LEFT JOIN categorias c ON p.id_categoria = c.id_categoria
        LEFT JOIN lotes l ON p.id_producto = l.id_producto
        GROUP BY p.id_producto;
    """
    
    cursor.execute(query)
    lista_productos = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('inventario.html', productos=lista_productos)

# 3. MOSTRAR FORMULARIO DE PRODUCTO
@app.route('/nuevo_producto')
def nuevo_producto():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    cursor.execute("SELECT id_categoria, nombre FROM categorias")
    cats = cursor.fetchall()
    
    cursor.execute("SELECT id_laboratorio, nombre FROM laboratorios")
    labs = cursor.fetchall()
    
    cursor.execute("SELECT id_presentacion, nombre FROM presentaciones")
    pres = cursor.fetchall()
    
    cursor.execute("SELECT id_unidad, nombre FROM unidades_medida")
    unis = cursor.fetchall()
    
    conn.close()
    
    return render_template('formulario_producto.html', 
                           categorias=cats, 
                           laboratorios=labs, 
                           presentaciones=pres, 
                           unidades=unis)

# 4. GUARDAR PRODUCTO EN BASE DE DATOS
@app.route('/guardar_producto', methods=['POST'])
def guardar_producto():
    # Recibimos los datos del HTML
    sku = request.form['sku']
    upc = request.form['upc']
    nombre = request.form['nombre']
    descripcion = request.form['descripcion']
    p_compra = request.form['precio_compra']
    p_venta = request.form['precio_venta']
    
    id_cat = request.form['id_categoria']
    id_lab = request.form['id_laboratorio']
    id_pres = request.form['id_presentacion']
    id_uni = request.form['id_unidad']

    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    sql = """INSERT INTO productos 
             (sku, upc, nombre, descripcion, precio_compra, precio_venta, 
              id_categoria, id_laboratorio, id_presentacion, id_unidad)
             VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
    
    valores = (sku, upc, nombre, descripcion, p_compra, p_venta, id_cat, id_lab, id_pres, id_uni)
    
    try:
        cursor.execute(sql, valores)
        conn.commit()
        conn.close()
        return redirect(url_for('inventario'))
    except Exception as e:
        return f"Error al guardar: {e}"

# 5. VER COMPRAS (Dashboard)
@app.route('/compras')
def compras():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    query = """
        SELECT 
            c.folio_factura,
            DATE_FORMAT(c.fecha_compra, '%Y-%m-%d'),
            p.nombre_comercial,
            c.total,
            u.username,
            c.estatus
        FROM compras_encabezado c
        JOIN proveedores p ON c.id_proveedor = p.id_proveedor
        JOIN usuarios u ON c.id_usuario = u.id_usuario
        ORDER BY c.fecha_compra DESC;
    """
    
    cursor.execute(query)
    lista_compras = cursor.fetchall()
    conn.close()
    return render_template('compras.html', compras=lista_compras)

# 6. MOSTRAR FORMULARIO DE NUEVA COMPRA
@app.route('/nueva_compra')
def nueva_compra():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    # 1. Traemos Proveedores
    cursor.execute("SELECT id_proveedor, nombre_comercial FROM proveedores WHERE estatus=1")
    proveedores = cursor.fetchall()
    
    # 2. Traemos Productos (CORREGIDO PARA BUSCADOR)
    # Concatenamos: UPC | SKU | Nombre
    # Usamos IFNULL para que si no tiene UPC, ponga vacío
    query_prod = """
        SELECT 
            id_producto, 
            CONCAT(IFNULL(upc, ''), ' | ', sku, ' | ', nombre) 
        FROM productos 
        WHERE estatus=1
    """
    cursor.execute(query_prod)
    productos = cursor.fetchall()
    
    conn.close()
    
    return render_template('formulario_compra.html', 
                           proveedores=proveedores, 
                           productos=productos)

# 7. GUARDAR COMPRA (CON CÁLCULO DE IVA)
@app.route('/guardar_compra', methods=['POST'])
def guardar_compra():
    datos = request.get_json()
    
    id_prov = datos['id_proveedor']
    folio = datos['folio_factura']
    fecha = datos['fecha_compra']
    lista_productos = datos['productos']
    
    # CÁLCULO DE TOTALES GLOBALES
    subtotal_global = sum(float(item['subtotal']) for item in lista_productos)
    impuestos_global = sum(float(item['monto_iva']) for item in lista_productos)
    total_global = subtotal_global + impuestos_global
    
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    try:
        # A. Crear Encabezado (Con desglose de impuestos)
        sql_header = """INSERT INTO compras_encabezado 
                        (folio_factura, fecha_compra, id_proveedor, id_usuario, subtotal, impuestos, total) 
                        VALUES (%s, %s, %s, 1, %s, %s, %s)"""
        cursor.execute(sql_header, (folio, fecha, id_prov, subtotal_global, impuestos_global, total_global))
        id_compra_nueva = cursor.lastrowid
        
        # B. Guardar Productos
        for item in lista_productos:
            # Nota: En la DB guardamos el costo unitario NETO (con iva o sin iva según tu regla de negocio)
            # Para simplificar y no cambiar la tabla, guardamos el costo unitario base
            sql_detail = """INSERT INTO compras_detalle 
                            (id_compra, id_producto, cantidad, costo_unitario, importe, lote_fabricante, fecha_caducidad) 
                            VALUES (%s, %s, %s, %s, %s, %s, %s)"""
            
            # El 'importe' en la tabla detalle será el Subtotal (Cantidad * Costo Base)
            cursor.execute(sql_detail, (
                id_compra_nueva, 
                item['id_producto'], 
                item['cantidad'], 
                item['costo'],      # Costo unitario base
                item['subtotal'],   # Importe sin impuestos
                item['lote'], 
                item['caducidad']
            ))
            
            # C. Inventario (Kárdex y Lotes)
            sql_lote = """INSERT INTO lotes 
                          (id_producto, numero_lote, fecha_caducidad, stock_inicial, stock_actual, costo_compra) 
                          VALUES (%s, %s, %s, %s, %s, %s)"""
            cursor.execute(sql_lote, (item['id_producto'], item['lote'], item['caducidad'], item['cantidad'], item['cantidad'], item['costo']))
            id_lote_nuevo = cursor.lastrowid
            
            sql_kardex = """INSERT INTO movimientos_inventario 
                            (id_producto, id_lote, tipo_movimiento, id_motivo, cantidad, stock_anterior, stock_resultante, id_usuario) 
                            VALUES (%s, %s, 'ENTRADA', 1, %s, 0, %s, 1)"""
            cursor.execute(sql_kardex, (item['id_producto'], id_lote_nuevo, item['cantidad'], item['cantidad']))
        
        conn.commit()
        return {'exito': True}
        
    except Exception as e:
        conn.rollback()
        print(f"Error: {e}")
        return {'exito': False, 'error': str(e)}

        
    
    finally:
        cursor.close()
        conn.close()
        # 8. PANTALLA PUNTO DE VENTA (POS)
@app.route('/ventas')
def ventas():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    # Traemos productos con su precio y stock para mostrarlos en el buscador
    # Nota: Ordenamos por nombre para facilitar búsqueda visual
    query = """
        SELECT 
            p.sku, 
            p.nombre, 
            p.precio_venta, 
            IFNULL(SUM(l.stock_actual), 0) as stock
        FROM productos p
        LEFT JOIN lotes l ON p.id_producto = l.id_producto
        WHERE p.estatus = 1
        GROUP BY p.id_producto
        ORDER BY p.nombre ASC;
    """
    
    cursor.execute(query)
    lista_productos = cursor.fetchall()
    conn.close()
    
    
    return render_template('ventas.html', productos=lista_productos)
    return redirect(url_for('compras'))
# 9. PROCESAR VENTA (EL CEREBRO FEFO)
@app.route('/procesar_venta', methods=['POST'])
def procesar_venta():
    carrito = request.get_json() # Recibimos la lista del carrito
    
    if not carrito:
        return {'exito': False, 'error': 'Carrito vacío'}

    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    try:
        # 1. Calcular totales generales para el Encabezado
        total_venta = sum(item['cantidad'] * item['precio'] for item in carrito)
        subtotal = total_venta # (Simplificado, aquí podrías desglosar IVA si quisieras)
        impuestos = 0
        
        # 2. Crear el Ticket (Encabezado)
        # Usamos Cliente 1 (Público General) y Usuario 1 (Admin) por defecto
        # Generamos un folio temporal con la fecha
        import datetime
        folio_ticket = "T-" + datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        
        sql_header = """INSERT INTO ventas_encabezado 
                        (folio_ticket, id_cliente, id_usuario, subtotal, impuestos, total, forma_pago) 
                        VALUES (%s, 1, 1, %s, %s, %s, 'Efectivo')"""
        cursor.execute(sql_header, (folio_ticket, subtotal, impuestos, total_venta))
        id_venta_nueva = cursor.lastrowid
        
        # 3. PROCESAR CADA PRODUCTO (LÓGICA FEFO)
        for item in carrito:
            sku = item['sku']
            cantidad_necesitada = int(item['cantidad'])
            precio_venta = item['precio']
            
            # A. Buscamos el ID del producto
            cursor.execute("SELECT id_producto, nombre FROM productos WHERE sku = %s", (sku,))
            prod_db = cursor.fetchone()
            if not prod_db:
                raise Exception(f"Producto {sku} no encontrado")
            
            id_producto = prod_db[0]
            nombre_prod = prod_db[1]
            
            # B. ALGORITMO FEFO: Traer lotes con stock, ordenados por caducidad (el más viejo primero)
            sql_lotes = """SELECT id_lote, stock_actual, numero_lote 
                           FROM lotes 
                           WHERE id_producto = %s AND stock_actual > 0 
                           ORDER BY fecha_caducidad ASC"""
            cursor.execute(sql_lotes, (id_producto,))
            lotes_disponibles = cursor.fetchall()
            
            cantidad_pendiente = cantidad_necesitada
            
            # C. Descontar de los lotes uno por uno
            for lote in lotes_disponibles:
                id_lote = lote[0]
                stock_lote = lote[1]
                
                if cantidad_pendiente <= 0:
                    break # Ya surtimos todo
                
                # Definir cuánto tomamos de este lote
                a_tomar = min(cantidad_pendiente, stock_lote)
                
                # Actualizar Lote en BD (Resta)
                cursor.execute("UPDATE lotes SET stock_actual = stock_actual - %s WHERE id_lote = %s", (a_tomar, id_lote))
                
                # Guardar en Detalle de Venta
                importe_linea = a_tomar * precio_venta
                sql_detalle = """INSERT INTO ventas_detalle 
                                 (id_venta, id_producto, id_lote, cantidad, precio_unitario, importe) 
                                 VALUES (%s, %s, %s, %s, %s, %s)"""
                cursor.execute(sql_detalle, (id_venta_nueva, id_producto, id_lote, a_tomar, precio_venta, importe_linea))
                
                # Registrar en Kárdex (Salida)
                sql_kardex = """INSERT INTO movimientos_inventario 
                                (id_producto, id_lote, tipo_movimiento, id_motivo, cantidad, stock_anterior, stock_resultante, id_usuario) 
                                VALUES (%s, %s, 'SALIDA', 2, %s, %s, %s, 1)""" # Motivo 2 = Venta
                cursor.execute(sql_kardex, (id_producto, id_lote, a_tomar, stock_lote, stock_lote - a_tomar))
                
                cantidad_pendiente -= a_tomar
            
            # D. Validación final: ¿Alcanzó el stock?
            if cantidad_pendiente > 0:
                raise Exception(f"No hay suficiente stock para {nombre_prod}. Faltaron {cantidad_pendiente}.")

        conn.commit()
        return {'exito': True, 'folio': folio_ticket}

    except Exception as e:
        conn.rollback()
        print(f"Error en venta: {e}")
        return {'exito': False, 'error': str(e)}
    
    finally:
        cursor.close()
        conn.close()

if __name__ == '__main__':
    app.run(debug=True, port=5000)