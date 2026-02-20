import tkinter as tk
from tkinter import messagebox, ttk, filedialog
import subprocess
import os
import threading
import shutil

# --- CONFIGURAÇÃO ---
PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(PROJECT_ROOT, "data", "DadosBrutos.csv")
SCRIPT_NORMAL = os.path.join(PROJECT_ROOT, "scripts", "compile_relatorio.sh")
SCRIPT_CONFIDENCIAL = os.path.join(PROJECT_ROOT, "scripts", "compile_relatorio_complexo.sh")
BUILD_DIR = os.path.join(PROJECT_ROOT, "build")

PDF_NORMAL = os.path.join(BUILD_DIR, "relatorio_excursoes.pdf")
PDF_CONFIDENCIAL = os.path.join(BUILD_DIR, "relatorio_confidencial.pdf")

# ---------------- VARIÁVEL DE ESTADO ----------------
ultimo_tipo = None  # 'normal' ou 'confidencial'

# ---------------- LOG ----------------
def log(msg, tag=None):
    text_log.configure(state="normal")
    if tag:
        text_log.insert(tk.END, msg + "\n", tag)
    else:
        text_log.insert(tk.END, msg + "\n")
    text_log.see(tk.END)
    text_log.configure(state="disabled")

# ---------------- FUNÇÕES ----------------
def toggle_confidencial():
    if var_confidencial.get():
        entry_senha.config(state="normal")
        entry_senha.focus()
    else:
        entry_senha.delete(0, tk.END)
        entry_senha.config(state="disabled")

def gerar_relatorio_thread():
    global ultimo_tipo

    if not os.path.exists(CSV_PATH):
        messagebox.showerror("Erro", f"CSV não encontrado em:\n{CSV_PATH}")
        return

    # Escolhe script e variáveis de ambiente
    if var_confidencial.get():
        senha = entry_senha.get().strip()
        if not senha:
            messagebox.showwarning("Aviso", "Digite a senha do PDF.")
            return
        script = SCRIPT_CONFIDENCIAL
        env = os.environ.copy()
        env["PDF_PASSWORD"] = senha
        log("Rodando Relatório Confidencial...", "info")
        ultimo_tipo = 'confidencial'
    else:
        script = SCRIPT_NORMAL
        env = None
        log("Rodando Relatório Normal...", "info")
        ultimo_tipo = 'normal'

    try:
        process = subprocess.Popen(
            [script, CSV_PATH],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            env=env
        )

        for line in iter(process.stdout.readline, ""):
            if "Erro" in line or "error" in line.lower():
                log(line.rstrip(), "error")
            else:
                log(line.rstrip())

        process.stdout.close()
        retcode = process.wait()
        if retcode == 0:
            log("✔ Relatório gerado com sucesso!", "success")
        else:
            log(f"❌ Erro na compilação. Código de saída: {retcode}", "error")

    except Exception as e:
        log(f"❌ Erro: {str(e)}", "error")

def gerar_relatorio():
    threading.Thread(target=gerar_relatorio_thread, daemon=True).start()

def abrir_pdf():
    if ultimo_tipo == 'confidencial':
        pdf_path = PDF_CONFIDENCIAL
    else:
        pdf_path = PDF_NORMAL

    if not os.path.exists(pdf_path):
        messagebox.showinfo("Info", f"Nenhum PDF encontrado para '{ultimo_tipo or 'nenhum'}'.")
        return

    try:
        subprocess.run(["xdg-open", pdf_path])
    except Exception as e:
        log(f"Erro ao abrir PDF: {str(e)}", "error")

def salvar_pdf():
    """Salva o último relatório em uma pasta escolhida pelo usuário"""
    if ultimo_tipo == 'confidencial':
        pdf_path = PDF_CONFIDENCIAL
    else:
        pdf_path = PDF_NORMAL

    if not os.path.exists(pdf_path):
        messagebox.showinfo("Info", f"Nenhum PDF encontrado para '{ultimo_tipo or 'nenhum'}'.")
        return

    destino = filedialog.asksaveasfilename(
        title="Salvar Relatório Como",
        defaultextension=".pdf",
        filetypes=[("PDF files", "*.pdf")],
        initialfile=os.path.basename(pdf_path)
    )

    if destino:
        try:
            shutil.copy2(pdf_path, destino)
            log(f"✔ PDF salvo em: {destino}", "success")
        except Exception as e:
            log(f"❌ Erro ao salvar PDF: {str(e)}", "error")

# ---------------- GUI ----------------
root = tk.Tk()
root.title("RelataCERJ")
root.geometry("540x480")
root.configure(bg="#f5f7fb")

# --- estilo moderno ---
style = ttk.Style()
style.theme_use("default")
style.configure("Blue.TButton", font=("Segoe UI", 10, "bold"), padding=8)
style.map("Blue.TButton", background=[("active", "#1e88e5"), ("!active", "#1976d2")], foreground=[("!disabled", "white")])
style.configure("TCheckbutton", background="#f5f7fb", font=("Segoe UI", 10))
style.configure("TLabel", background="#f5f7fb", font=("Segoe UI", 10))

# --- container principal ---
main = ttk.Frame(root, padding=15)
main.pack(fill="both", expand=True)

titulo = ttk.Label(main, text="RelataCERJ", font=("Segoe UI", 16, "bold"))
titulo.pack(anchor="w", pady=(0, 10))

# Botão Gerar Relatório
ttk.Button(main, text="Gerar Relatório", style="Blue.TButton", command=gerar_relatorio).pack(fill="x", pady=3)

# Frame horizontal para Abrir e Salvar PDF lado a lado
frame_pdf = ttk.Frame(main)
frame_pdf.pack(fill="x", pady=3)

btn_abrir = ttk.Button(frame_pdf, text="Abrir PDF", style="Blue.TButton", command=abrir_pdf)
btn_abrir.pack(side="left", expand=True, fill="x", padx=(0, 5))

btn_salvar = ttk.Button(frame_pdf, text="Salvar PDF", style="Blue.TButton", command=salvar_pdf)
btn_salvar.pack(side="left", expand=True, fill="x", padx=(5, 0))

var_confidencial = tk.BooleanVar()
ttk.Checkbutton(main, text="Relatório Confidencial", variable=var_confidencial, command=toggle_confidencial).pack(anchor="w", pady=(12,0))

ttk.Label(main, text="Digite a senha:").pack(anchor="w")
entry_senha = ttk.Entry(main, show="*", state="disabled")
entry_senha.pack(fill="x", pady=(0, 10))

# Log
frame_log = ttk.Frame(main)
frame_log.pack(fill="both", expand=True)
text_log = tk.Text(frame_log, height=14, bg="#ffffff", fg="#1a1a1a", font=("Consolas", 9), relief="flat", borderwidth=1, state="disabled")
text_log.pack(fill="both", expand=True)

# tags de cores
text_log.tag_config("error", foreground="red")
text_log.tag_config("success", foreground="green")
text_log.tag_config("info", foreground="#1976d2")  # azul

root.mainloop()
