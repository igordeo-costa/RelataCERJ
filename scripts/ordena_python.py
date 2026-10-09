import csv
import unicodedata

entrada = "DadosBrutos.csv"
saida = "DadosBrutos_ordenado.csv"


def chave_alfabetica(nome):
    # Remove espaços no início/fim
    nome = nome.strip()

    # Remove caracteres invisíveis / de formatação Unicode
    nome = "".join(
        c for c in nome
        if unicodedata.category(c) != "Cf"
    )

    # Normaliza Unicode
    nome = unicodedata.normalize("NFD", nome)

    # Remove os acentos apenas para a comparação
    nome = "".join(
        c for c in nome
        if unicodedata.category(c) != "Mn"
    )

    # Ignora diferenças entre maiúsculas/minúsculas
    return nome.casefold()


with open(entrada, "r", encoding="utf-8", newline="") as f_in, \
     open(saida, "w", encoding="utf-8", newline="") as f_out:

    reader = csv.reader(f_in)
    writer = csv.writer(f_out)

    for linha in reader:
        if len(linha) > 9:
            nomes = [
                nome.strip()
                for nome in linha[9].split(",")
            ]

            # Remove caracteres invisíveis dos nomes
            nomes = [
                "".join(
                    c for c in nome
                    if unicodedata.category(c) != "Cf"
                ).strip()
                for nome in nomes
            ]

            # Ordena alfabeticamente
            nomes.sort(key=chave_alfabetica)

            linha[9] = ", ".join(nomes)

        writer.writerow(linha)

print(f"Cópia criada: {saida}")
