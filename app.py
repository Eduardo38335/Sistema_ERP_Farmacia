from flask import Flask, render_template, request, redirect, url_for, session, flash
import mysql.connector
from functools import wraps
import datetime 

# Importamos tu configuración (asegúrate que config.py esté bien)
from config import DB_CONFIG 

app = Flask(__name__)

# 🔐 LLAVE MAESTRA (Necesaria para las sesiones)
app.secret_key = 'super_secreto_farmacia_2025'

# ==========================================
# 🛡️ DECORADORES DE SEGURIDAD
# ==========================================
@app.after_request
def add_header(response):
    """
    Le dice al navegador que NO guarde nada en la memoria caché.
    Así, al dar 'Atrás', el navegador se ve obligado a pedir la página al servidor,
    el servidor detecta que no hay sesión y lo manda al Login.
    """
    response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0, max-age=0'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '-1'
    return response


# 1. Verifica si estás logueado
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            flash("⚠️ Debes iniciar sesión para acceder.", "warning")
            return redirect(url_for('login'))
        return f(*args, **kwargs)
    return decorated_function

# 2. Verifica si eres Administrador (Rol 1)
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get('rol') != 1:
            flash("⛔ Acceso denegado. Se requieren permisos de Administrador.", "danger")
            return redirect(url_for('inicio'))
        return f(*args, **kwargs)
    return decorated_function

# ==========================================
# 🚪 ACCESO (LOGIN / LOGOUT)
# ==========================================
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        usuario = request.form['username']
        password = request.form['password']
        
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        # Buscamos usuario activo
        cursor.execute("SELECT * FROM usuarios WHERE username = %s AND estatus = 1", (usuario,))
        user_db = cursor.fetchone()
        conn.close()
        
        if user_db and user_db['password'] == password:
            # ¡Login Exitoso! Guardamos datos en la sesión
            session['user_id'] = user_db['id_usuario']
            session['nombre'] = user_db['nombres']
            session['rol'] = user_db['id_rol']
            return redirect(url_for('inicio'))
        else:
            flash("❌ Usuario o contraseña incorrectos.", "danger")
            
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.clear() # Borramos la sesión
    return redirect(url_for('login'))

# ==========================================
# 🏠 INICIO
# ==========================================
@app.route('/')
@login_required
def inicio():
    return render_template('index.html')

# ==========================================
# 👥 MÓDULO USUARIOS (Solo Admin)
# ==========================================
@app.route('/usuarios')
@login_required
@admin_required
def usuarios():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT u.*, r.nombre as rol FROM usuarios u JOIN roles r ON u.id_rol = r.id_rol ORDER BY u.id_usuario")
    lista = cursor.fetchall()
    conn.close()
    return render_template('usuarios.html', usuarios=lista)

@app.route('/usuario_form')
@app.route('/usuario_form/<int:id>')
@login_required
@admin_required
def usuario_form(id=None):
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM roles WHERE estatus=1")
    roles = cursor.fetchall()
    
    usuario_data = None
    if id:
        cursor.execute("SELECT * FROM usuarios WHERE id_usuario = %s", (id,))
        usuario_data = cursor.fetchone()
    conn.close()
    return render_template('formulario_usuario.html', roles=roles, usuario=usuario_data)

@app.route('/guardar_usuario', methods=['POST'])
@login_required
@admin_required
def guardar_usuario():
    # Recibimos datos
    id_u = request.form['id_usuario']
    nom = request.form['nombres']
    pat = request.form['paterno']
    mat = request.form['materno']
    user = request.form['username']
    pwd = request.form['password']
    rol = request.form['id_rol']
    estatus = 1 if 'estatus' in request.form else 0
    
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    try:
        if not id_u: # CREAR
            cursor.execute("INSERT INTO usuarios (nombres, apellido_paterno, apellido_materno, username, password, id_rol, estatus) VALUES (%s,%s,%s,%s,%s,%s,%s)", (nom, pat, mat, user, pwd, rol, estatus))
            flash("Usuario creado.", "success")
        else: # EDITAR
            if pwd: # Si cambió contraseña
                cursor.execute("UPDATE usuarios SET nombres=%s, apellido_paterno=%s, apellido_materno=%s, username=%s, password=%s, id_rol=%s, estatus=%s WHERE id_usuario=%s", (nom, pat, mat, user, pwd, rol, estatus, id_u))
            else: # Si NO cambió contraseña
                cursor.execute("UPDATE usuarios SET nombres=%s, apellido_paterno=%s, apellido_materno=%s, username=%s, id_rol=%s, estatus=%s WHERE id_usuario=%s", (nom, pat, mat, user, rol, estatus, id_u))
            flash("Usuario actualizado.", "success")
        conn.commit()
    except Exception as e:
        flash(f"Error: {e}", "danger")
    finally:
        conn.close()
    return redirect(url_for('usuarios'))

# ==========================================
# 📦 MÓDULO INVENTARIO Y PRODUCTOS
# ==========================================
@app.route('/inventario')
@login_required
def inventario():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    query = """
        SELECT p.sku, p.upc, p.nombre, p.descripcion, c.nombre, 
               IFNULL(SUM(l.stock_actual), 0), p.precio_venta
        FROM productos p
        LEFT JOIN categorias c ON p.id_categoria = c.id_categoria
        LEFT JOIN lotes l ON p.id_producto = l.id_producto
        GROUP BY p.id_producto;
    """
    cursor.execute(query)
    lista = cursor.fetchall()
    conn.close()
    return render_template('inventario.html', productos=lista)

@app.route('/nuevo_producto')
@login_required
@admin_required # Solo admin crea productos
def nuevo_producto():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    # Cargamos catálogos
    cursor.execute("SELECT id_categoria, nombre FROM categorias")
    cats = cursor.fetchall()
    cursor.execute("SELECT id_laboratorio, nombre FROM laboratorios")
    labs = cursor.fetchall()
    cursor.execute("SELECT id_presentacion, nombre FROM presentaciones")
    pres = cursor.fetchall()
    cursor.execute("SELECT id_unidad, nombre FROM unidades_medida")
    unis = cursor.fetchall()
    conn.close()
    return render_template('formulario_producto.html', categorias=cats, laboratorios=labs, presentaciones=pres, unidades=unis)

@app.route('/guardar_producto', methods=['POST'])
@login_required
@admin_required
def guardar_producto():
    d = request.form
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    try:
        sql = "INSERT INTO productos (sku, upc, nombre, descripcion, precio_compra, precio_venta, id_categoria, id_laboratorio, id_presentacion, id_unidad) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        cursor.execute(sql, (d['sku'], d['upc'], d['nombre'], d['descripcion'], d['precio_compra'], d['precio_venta'], d['id_categoria'], d['id_laboratorio'], d['id_presentacion'], d['id_unidad']))
        conn.commit()
    except Exception as e:
        return f"Error: {e}"
    finally:
        conn.close()
    return redirect(url_for('inventario'))

# ==========================================
# 🚚 MÓDULO COMPRAS
# ==========================================
@app.route('/compras')
@login_required
def compras():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("SELECT c.folio_factura, DATE_FORMAT(c.fecha_compra, '%Y-%m-%d'), p.nombre_comercial, c.total, u.username, c.estatus FROM compras_encabezado c JOIN proveedores p ON c.id_proveedor = p.id_proveedor JOIN usuarios u ON c.id_usuario = u.id_usuario ORDER BY c.fecha_compra DESC")
    lista = cursor.fetchall()
    conn.close()
    return render_template('compras.html', compras=lista)

@app.route('/nueva_compra')
@login_required
@admin_required
def nueva_compra():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("SELECT id_proveedor, nombre_comercial FROM proveedores WHERE estatus=1")
    provs = cursor.fetchall()
    cursor.execute("SELECT id_producto, CONCAT(IFNULL(upc,''), ' | ', sku, ' | ', nombre) FROM productos WHERE estatus=1")
    prods = cursor.fetchall()
    conn.close()
    return render_template('formulario_compra.html', proveedores=provs, productos=prods)

@app.route('/guardar_compra', methods=['POST'])
@login_required
@admin_required
def guardar_compra():
    datos = request.get_json()
    id_usuario = session['user_id']
    
    subtotal_global = sum(float(x['subtotal']) for x in datos['productos'])
    impuestos_global = sum(float(x['monto_iva']) for x in datos['productos'])
    total_global = subtotal_global + impuestos_global
    
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    try:
        # A. Encabezado
        cursor.execute("INSERT INTO compras_encabezado (folio_factura, fecha_compra, id_proveedor, id_usuario, subtotal, impuestos, total) VALUES (%s, %s, %s, %s, %s, %s, %s)", 
                       (datos['folio_factura'], datos['fecha_compra'], datos['id_proveedor'], id_usuario, subtotal_global, impuestos_global, total_global))
        id_compra = cursor.lastrowid
        
        # B. Detalles, Lotes y Kárdex
        for item in datos['productos']:
            # Detalle
            cursor.execute("INSERT INTO compras_detalle (id_compra, id_producto, cantidad, costo_unitario, importe, lote_fabricante, fecha_caducidad) VALUES (%s, %s, %s, %s, %s, %s, %s)",
                           (id_compra, item['id_producto'], item['cantidad'], item['costo'], item['subtotal'], item['lote'], item['caducidad']))
            # Lote
            cursor.execute("INSERT INTO lotes (id_producto, numero_lote, fecha_caducidad, stock_inicial, stock_actual, costo_compra) VALUES (%s, %s, %s, %s, %s, %s)",
                           (item['id_producto'], item['lote'], item['caducidad'], item['cantidad'], item['cantidad'], item['costo']))
            id_lote = cursor.lastrowid
            # Kárdex
            cursor.execute("INSERT INTO movimientos_inventario (id_producto, id_lote, tipo_movimiento, id_motivo, cantidad, stock_anterior, stock_resultante, id_usuario) VALUES (%s, %s, 'ENTRADA', 1, %s, 0, %s, %s)",
                           (item['id_producto'], id_lote, item['cantidad'], item['cantidad'], id_usuario))
        
        conn.commit()
        return {'exito': True}
    except Exception as e:
        conn.rollback()
        return {'exito': False, 'error': str(e)}
    finally:
        conn.close()

# ==========================================
# 🛒 MÓDULO VENTAS (POS)
# ==========================================
@app.route('/ventas')
@login_required
def ventas():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    # Traemos productos con stock
    cursor.execute("SELECT p.sku, p.nombre, p.precio_venta, IFNULL(SUM(l.stock_actual), 0) FROM productos p LEFT JOIN lotes l ON p.id_producto = l.id_producto WHERE p.estatus = 1 GROUP BY p.id_producto ORDER BY p.nombre ASC")
    lista = cursor.fetchall()
    conn.close()
    return render_template('ventas.html', productos=lista)

@app.route('/procesar_venta', methods=['POST'])
@login_required
def procesar_venta():
    carrito = request.get_json()
    id_usuario = session['user_id']
    if not carrito: return {'exito': False, 'error': 'Carrito vacío'}

    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    try:
        # Totales
        total_venta = sum(item['cantidad'] * item['precio'] for item in carrito)
        folio = "T-" + datetime.datetime.now().strftime("%Y%m%d%H%M%S")
        
        # Encabezado
        cursor.execute("INSERT INTO ventas_encabezado (folio_ticket, id_cliente, id_usuario, subtotal, impuestos, total, forma_pago) VALUES (%s, 1, %s, %s, 0, %s, 'Efectivo')", 
                       (folio, id_usuario, total_venta, total_venta))
        id_venta = cursor.lastrowid
        
        # Procesar Items (Lógica FEFO)
        for item in carrito:
            sku = item['sku']
            qty = int(item['cantidad'])
            
            # Buscar ID producto
            cursor.execute("SELECT id_producto FROM productos WHERE sku = %s", (sku,))
            id_prod = cursor.fetchone()[0]
            
            # Buscar lotes (FEFO)
            cursor.execute("SELECT id_lote, stock_actual FROM lotes WHERE id_producto = %s AND stock_actual > 0 ORDER BY fecha_caducidad ASC", (id_prod,))
            lotes = cursor.fetchall()
            
            pendiente = qty
            for lote in lotes:
                if pendiente <= 0: break
                id_lote, stock = lote
                tomar = min(pendiente, stock)
                
                # Descontar Stock
                cursor.execute("UPDATE lotes SET stock_actual = stock_actual - %s WHERE id_lote = %s", (tomar, id_lote))
                # Guardar Detalle
                cursor.execute("INSERT INTO ventas_detalle (id_venta, id_producto, id_lote, cantidad, precio_unitario, importe) VALUES (%s, %s, %s, %s, %s, %s)", 
                               (id_venta, id_prod, id_lote, tomar, item['precio'], tomar * item['precio']))
                # Kárdex Salida
                cursor.execute("INSERT INTO movimientos_inventario (id_producto, id_lote, tipo_movimiento, id_motivo, cantidad, stock_anterior, stock_resultante, id_usuario) VALUES (%s, %s, 'SALIDA', 2, %s, %s, %s, %s)", 
                               (id_prod, id_lote, tomar, stock, stock - tomar, id_usuario))
                pendiente -= tomar
            
            if pendiente > 0: raise Exception(f"Stock insuficiente para {sku}")

        conn.commit()
        return {'exito': True, 'folio': folio}
    except Exception as e:
        conn.rollback()
        return {'exito': False, 'error': str(e)}
    finally:
        conn.close()

# 10. TICKET
@app.route('/ticket/<folio>')
@login_required
def ticket(folio):
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT v.folio_ticket, v.fecha_venta, v.total, u.username as vendedor FROM ventas_encabezado v JOIN usuarios u ON v.id_usuario = u.id_usuario WHERE v.folio_ticket = %s", (folio,))
    venta = cursor.fetchone()
    
    cursor2 = conn.cursor() # Cursor normal para detalles
    cursor2.execute("SELECT d.cantidad, p.nombre, l.numero_lote, d.importe FROM ventas_detalle d JOIN productos p ON d.id_producto = p.id_producto JOIN lotes l ON d.id_lote = l.id_lote WHERE d.id_venta = (SELECT id_venta FROM ventas_encabezado WHERE folio_ticket = %s)", (folio,))
    detalles = cursor2.fetchall()
    
    conn.close()
    return render_template('ticket.html', venta=venta, detalles=detalles)

# 14. MÓDULO IA
@app.route('/ia')
@login_required
def ia():
    return render_template('base.html') # Pendiente

if __name__ == '__main__':
    app.run(debug=True, port=5000)