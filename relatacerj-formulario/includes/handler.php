<?php
defined('ABSPATH') || exit;

add_action('init', 'relatacerj_processar_formulario');

function relatacerj_lista_guias() {
    return [
    'Alexandre Gomes',
    'Bruno Waldman',
    'Caiê Visintin',
    'Carla Romão',
    'Daniel Rodriguez',
    'Henrique Menescal',
    'Jana Menezes',
    'Júlio Mello',
    'Kátia Perensim',
    'Livia Cardoso',
    'Luiz Puppin',
    'Marcelo Magal',
    'Mariana Lopes',
    'Mariozinho Richard',
    'Miriam Gerber',
    'Pedro Bugim',
    'Thiago Gabriel',
    'Valéria Aquino',
    'Velho Fajardo',
    'Waldecy Lucena',
    'Yvie Barcellos',
    'Zé Kili'
    ];
}


add_action('wp_ajax_relatacerj_buscar_guias', 'relatacerj_buscar_guias');
add_action('wp_ajax_nopriv_relatacerj_buscar_guias', 'relatacerj_buscar_guias');

function relatacerj_buscar_guias() {
    $term = sanitize_text_field($_GET['term'] ?? '');
    $guias = relatacerj_lista_guias();

    $resultados = array_filter($guias, function ($guia) use ($term) {
        return stripos($guia, $term) !== false;
    });

    wp_send_json(array_values($resultados));
}

function relatacerj_normalizar_data($data) {
    if (empty($data)) {
        return '';
    }

    $dt = DateTime::createFromFormat('Y-m-d', $data);

    if (!$dt) {
        return '';
    }

    return $dt->format('d/m/Y');
}

function relatacerj_normalizar_hora($hora) {
    if (empty($hora)) {
        return '';
    }

    $dt = DateTime::createFromFormat('H:i', $hora);
    return $dt ? $dt->format('H:i') : '';
}

function relatacerj_processar_formulario() {

    if (
        !isset($_POST['relatacerj_submit']) ||
        !isset($_POST['relatacerj_nonce']) ||
        !wp_verify_nonce($_POST['relatacerj_nonce'], 'relatacerj_salvar')
    ) {
        return;
    }

    // 👉 PRIMEIRO criamos o array de dados
    $dados = [
        'timestamp'            => current_time('Y-m-d H:i:s'),
        'guia'                 => sanitize_text_field($_POST['guia'] ?? ''),
        'demais_guias'         => sanitize_text_field($_POST['demais_guias'] ?? ''),
        'guias_auxiliares'     => sanitize_text_field($_POST['guias_auxiliares'] ?? ''),
        'excursao'             => sanitize_text_field($_POST['excursao'] ?? ''),
        'local'                => sanitize_text_field($_POST['local'] ?? ''),
        'categoria'            => sanitize_text_field($_POST['categoria'] ?? ''),
        'data_inicio' 	       => relatacerj_normalizar_data($_POST['data_inicio'] ?? ''),
	'data_fim'    	       => relatacerj_normalizar_data($_POST['data_fim'] ?? ''),
	'hora_inicio' 	       => relatacerj_normalizar_hora($_POST['hora_inicio'] ?? ''),
	'hora_fim'    	       => relatacerj_normalizar_hora($_POST['hora_fim'] ?? ''),
        'condicoes_climaticas' => sanitize_text_field($_POST['condicoes_climaticas'] ?? ''),
        'participantes'        => sanitize_textarea_field($_POST['participantes'] ?? ''),
        'relato'               => sanitize_textarea_field($_POST['relato'] ?? ''),
        'pontos_atencao'       => sanitize_textarea_field($_POST['pontos_atencao'] ?? ''),
        'preenchido_por'       => sanitize_text_field($_POST['preenchido_por'] ?? ''),
    ];

    // 👉 AGORA sim validamos o guia
    $guias_validos = relatacerj_lista_guias();
    if (!in_array($dados['guia'], $guias_validos, true)) {
        return; // guia inválido → não grava
    }

    // 👉 Grava no CSV
    $upload_dir = wp_upload_dir();
    $csv_path = $upload_dir['basedir'] . '/relatos_excursao.csv';

    $novo = !file_exists($csv_path);
    $fp = fopen($csv_path, 'a');

    if ($novo) {
        fputcsv($fp, array_keys($dados));
    }

    fputcsv($fp, array_values($dados));
    fclose($fp);
}

