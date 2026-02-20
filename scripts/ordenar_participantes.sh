#!/usr/bin/env bash
gawk -v FPAT='([^,]*)|("([^"]|"")*")' '
BEGIN { OFS="," }

NR==1 { print; next }  # mantém cabeçalho

{
    campo = $10

    # remove aspas externas
    sub(/^"/, "", campo)
    sub(/"$/, "", campo)

    # divide participantes
    n = split(campo, nomes, /, */)

    # ordena alfabeticamente
    asort(nomes)

    # reconstrói lista
    lista = nomes[1]
    for (i = 2; i <= n; i++) {
        lista = lista ", " nomes[i]
    }

    # recoloca aspas
    $10 = "\"" lista "\""

    print
}
' "$1"
