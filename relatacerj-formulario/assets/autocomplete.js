document.addEventListener('DOMContentLoaded', () => {
    const input = document.querySelector('input[name="guia"]');
    if (!input) return;

    let lista;

    input.addEventListener('input', async () => {
        const termo = input.value;
        if (termo.length < 2) return;

        const res = await fetch(
            `${relatacerj.ajax_url}?action=relatacerj_buscar_guias&term=${encodeURIComponent(termo)}`
        );

        const dados = await res.json();

        if (lista) lista.remove();

        lista = document.createElement('ul');
        lista.className = 'relatacerj-autocomplete';

        dados.forEach(nome => {
            const item = document.createElement('li');
            item.textContent = nome;
            item.onclick = () => {
                input.value = nome;
                lista.remove();
            };
            lista.appendChild(item);
        });

        input.parentNode.appendChild(lista);
    });
});

