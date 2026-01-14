import pandas as pd
import re

# ===== CONFIGURACIÓN =====
EXCEL_PATH = "Libro1.xlsx"        # tu archivo
SHEET_NAME = "Pagos"             # hoja
OUTPUT_SQL = "insert_pago_mensual.sql"

# columnas EXACTAS del excel
COL_CONTRATO_ID = "contrato_arriendo_id"
COL_TIPO = "tipo"
COL_MES = "mes"
COL_ANIO = "anio"
COL_VALOR = "valor_arriendo"
COL_ADMIN = "cuota_administracion"
COL_FONDO = "fondo_inmueble"
COL_TOTAL = "total_neto"
COL_FECHA_PAGO = "fecha_pago"

# ===== FUNCIONES =====
def limpiar_numero(valor):
    if pd.isna(valor) or str(valor).strip() in ["-", ""]:
        return "NULL"
    valor = re.sub(r"[^\d]", "", str(valor))
    return valor if valor else "NULL"

def limpiar_texto(valor):
    if pd.isna(valor):
        return ""
    return str(valor).strip()

def limpiar_fecha(valor):
    if pd.isna(valor):
        return "NULL"
    return f"'{pd.to_datetime(valor).date()}'"

# ===== LEER EXCEL =====
df = pd.read_excel(EXCEL_PATH, sheet_name=SHEET_NAME)

inserts = []
for _, r in df.iterrows():
    insert = f"""(
'{r[COL_CONTRATO_ID]}',
'{limpiar_texto(r[COL_TIPO])}',
'{limpiar_texto(r[COL_MES])}',
'{limpiar_texto(r[COL_ANIO])}',
{limpiar_numero(r[COL_VALOR])},
{limpiar_numero(r[COL_ADMIN])},
{limpiar_numero(r[COL_FONDO])},
{limpiar_numero(r[COL_TOTAL])},
{limpiar_fecha(r[COL_FECHA_PAGO])}
)"""
    inserts.append(insert)

# ===== ARMAR SQL =====
sql = """INSERT INTO pago_mensual (
contrato_arriendo_id,
tipo,
mes,
anio,
valor_arriendo,
cuota_administracion,
fondo_inmueble,
total_neto,
fecha_pago
) VALUES
"""
sql += ",\n".join(inserts)
sql += "\nON CONFLICT DO NOTHING;"

# ===== GUARDAR =====
with open(OUTPUT_SQL, "w", encoding="utf-8") as f:
    f.write(sql)

print(f"✅ Archivo generado: {OUTPUT_SQL}")
