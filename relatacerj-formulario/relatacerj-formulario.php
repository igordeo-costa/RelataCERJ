<?php
/**
 * Plugin Name: RelataCERJ - Formulário
 * Description: Formulário simples que gera CSV normalizado
 * Version: 1.0
 */

defined('ABSPATH') || exit;

require_once plugin_dir_path(__FILE__) . 'includes/relato_excursao.php';
require_once plugin_dir_path(__FILE__) . 'includes/handler.php';

add_action('wp_enqueue_scripts', function () {
    wp_enqueue_style(
        'relatacerj-form-style',
        plugin_dir_url(__FILE__) . 'assets/form.css',
        [],
        '1.0'
    );
});

add_action('wp_enqueue_scripts', function () {
    wp_enqueue_script(
        'relatacerj-autocomplete',
        plugin_dir_url(__FILE__) . 'assets/autocomplete.js',
        [],
        null,
        true
    );

    wp_localize_script('relatacerj-autocomplete', 'relatacerj', [
        'ajax_url' => admin_url('admin-ajax.php')
    ]);
});



