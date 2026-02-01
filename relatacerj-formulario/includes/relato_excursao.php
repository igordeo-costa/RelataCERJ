<?php
defined('ABSPATH') || exit;

function relatacerj_shortcode_formulario() {
    ob_start();
    ?>
    <form method="post" class="relatacerj-form">
        <?php wp_nonce_field('relatacerj_salvar', 'relatacerj_nonce'); ?>

        <h2>Relato de Excursão</h2>

        <div class="relatacerj-field">
            <label>Guia</label>
            <p class="relatacerj-help">
                Nome do guia responsável pela excursão.
            </p>
            <input type="text" name="guia" required>
        </div>

        <div class="relatacerj-field">
            <label>Demais Guias</label>
            <p class="relatacerj-help">
                Preencha em caso de haver mais de um guia responsável pela atividade.
            </p>
            <input type="text" name="demais_guias">
        </div>

        <div class="relatacerj-field">
            <label>Auxiliar(es)</label>
            <p class="relatacerj-help">
                Informe os auxiliares que atuaram na atividade, se houver.
            </p>
            <input type="text" name="guias_auxiliares">
        </div>

        <div class="relatacerj-field">
            <label>Excursão</label>
            <p class="relatacerj-help">
                Nome oficial da excursão realizada.
            </p>
            <input type="text" name="excursao" required>
        </div>

        <div class="relatacerj-field">
            <label>Local</label>
            <p class="relatacerj-help">
                Local principal da atividade (país, estado, parque, região, etc).
            </p>
            <input type="text" name="local">
        </div>

        <div class="relatacerj-field">
            <label>Categoria</label>
            <p class="relatacerj-help">
                Categoria e/ou tipo de atividade principal da excursão.
            </p>
            <select name="categoria" required>
        <option value="">Selecione a categoria</option>

        <option value="Caminhada leve">Caminhada leve</option>
        <option value="Caminhada moderada">Caminhada moderada</option>
        <option value="Caminhada pesada">Caminhada pesada</option>

        <option value="Manejo/Reabertura de trilha de caminhada">
            Manejo/Reabertura de trilha de caminhada
        </option>

        <option value="Escalada Tradicional">Escalada Tradicional</option>
        <option value="Escalada Esportiva">Escalada Esportiva</option>
        <option value="Escalada com Top Rope/Campo Escola">
            Escalada com Top Rope / Campo Escola
        </option>

        <option value="Conquista/Manutenção de Via de Escalada">
            Conquista/Manutenção de Via de Escalada
        </option>
    </select>
        </div>

        <div class="relatacerj-grid">
            <div class="relatacerj-field">
                <label>Data de Início</label>
                <input type="date" name="data_inicio">
            </div>

            <div class="relatacerj-field">
                <label>Hora de Início</label>
                <input type="time" name="hora_inicio">
            </div>

            <div class="relatacerj-field">
                <label>Data de Término</label>
                <input type="date" name="data_fim">
            </div>

            <div class="relatacerj-field">
                <label>Hora de Término</label>
                <input type="time" name="hora_fim">
            </div>
        </div>

        <div class="relatacerj-field">
            <label>Condições Climáticas Gerais</label>
            <p class="relatacerj-help">
                Descreva de forma geral o clima durante a atividade (sol, chuva, vento, neblina, etc).
            </p>
            <input type="text" name="condicoes_climaticas">
        </div>

        <div class="relatacerj-field">
            <label>Participantes</label>
            <p class="relatacerj-help">
                Informe os nomes separados por vírgula. Não utilize “e” para separar o último nome.
            </p>
            <textarea name="participantes"></textarea>
        </div>

        <div class="relatacerj-field">
            <label>Relato de Eventos / Observações</label>
            <p class="relatacerj-help">
                Descreva acontecimentos relevantes, incidentes, decisões importantes ou observações gerais.
            </p>
            <textarea name="relato"></textarea>
        </div>

        <div class="relatacerj-field">
            <label>Pontos de Atenção</label>
            <p class="relatacerj-help">
                Informações críticas e/ou sensíveis sobre a atividade, eventos, sócios do clube, etc durante a excursão. Essa informação é destinada exclusivamente à Diretoria Técnica, não estando visível no relatório.
            </p>
            <textarea name="pontos_atencao"></textarea>
        </div>

        <div class="relatacerj-field">
            <label>Relatório preenchido por</label>
            <p class="relatacerj-help">
                Nome da pessoa responsável pelo preenchimento deste relatório.
            </p>
            <input type="text" name="preenchido_por">
        </div>

        <div class="relatacerj-submit">
            <button type="submit" name="relatacerj_submit">
                Registrar Relato
            </button>
        </div>
    </form>
    <?php
    return ob_get_clean();
}

add_shortcode('relato_excursao', 'relatacerj_shortcode_formulario');

