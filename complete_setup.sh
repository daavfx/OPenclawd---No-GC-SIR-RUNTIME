#!/bin/bash
# complete_setup.sh - Final setup commands

cd /home/daavfx/Desktop/f-v23.6.0-Ryiuk_final_form_3.0/v14.0.0-Ryiuk_synthetic_evolution_1.0/ryiuk-core/tsc-rust/TypeScript-Rust-Compiler/typescript_rust/openclawd_nogc

echo "Configuring git..."
git config user.email "daavfx@github.com"
git config user.name "daavfx"

echo "Adding remote..."
git remote add origin https://github.com/daavfx/OPenclawd---No-GC-SIR-RUNTIME.git

echo "Pushing to GitHub..."
echo "When prompted for password, type: Daavile95$"
git push -u origin main

echo "Done!"