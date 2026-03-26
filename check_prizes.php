<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

echo "=== PREMIOS CADASTRADOS ===\n";
$prizes = App\Models\Prize::where('status', 1)->get();
echo "Total: " . $prizes->count() . "\n\n";

foreach($prizes as $p) {
    echo "ID: " . $p->id . " | Bet: R$" . $p->bet . " | Amount: R$" . $p->amount . " | Image: " . ($p->image ?? 'NULL') . " | Gift: " . ($p->gift_image ?? 'NULL') . "\n";
}

echo "\n=== ULTIMA ORDER ===\n";
$order = App\Models\Order::orderBy('id', 'desc')->first();
echo "ID: " . $order->id . "\n";
echo "Status: " . $order->status . "\n";
echo "Prize ID: " . ($order->prize_id ?? 'NULL') . "\n";
echo "Win Amount: " . $order->win_amount . "\n";
echo "Bet Amount: " . $order->bet_amount . "\n";

if ($order->prize_id) {
    $prize = App\Models\Prize::find($order->prize_id);
    echo "\nPrize encontrado:\n";
    echo "Image: " . ($prize->image ?? 'NULL') . "\n";
    echo "Gift Image: " . ($prize->gift_image ?? 'NULL') . "\n";
}
