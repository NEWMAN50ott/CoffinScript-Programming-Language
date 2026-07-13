#!/bin/sh
echo "======================================================="
echo "  csc Compiler Builder Engine (customasm Target)"
echo "======================================================="

if ! command -v customasm &> /dev/null
then
    echo "[ERROR] customasm utility was not found in your system PATH."
    echo "Please download customasm (https://github.com) to continue."
    exit 1
fi

echo "Packing machine tokens into flat binary layout..."
customasm csc.asm -f binary -o csc.bin

if [ $? -eq 0 ]; then
    echo "[SUCCESS] csc.bin generated successfully!"
else
    echo "[ERROR] Compilation failed. Check csc.asm syntax."
    exit 1
fi
