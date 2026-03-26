<?php require 'vendor/autoload.php'; \ = require 'bootstrap/app.php'; \->make('Illuminate\Contracts\Console\Kernel')->bootstrap(); \ = App\Models\Deposit::find(5); print_r(\->toArray());
