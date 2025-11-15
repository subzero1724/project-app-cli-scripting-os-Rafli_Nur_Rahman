#!/bin/bash

# Warna ANSI
RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
CYAN='\e[36m'
RESET='\e[0m'

# Array untuk menyimpan transaksi
declare -a NAMA
declare -a TIPE
declare -a HARGA
declare -a JUMLAH
declare -a TOTAL


header() {
    echo -e "${CYAN}"
    echo "============================================="
    echo "           APLIKASI TRANSAKSI SEPATU         "
    echo "============================================="
    echo -e "${RESET}"
}

validate_not_empty() {
    if [ -z "$1" ]; then
        echo -e "${RED}Input tidak boleh kosong!${RESET}"
        return 1
    fi
    return 0
}

pilih_tipe() {
    echo "Pilih tipe sepatu:"
    echo "1. Sneaker  (Rp 350000)"
    echo "2. Running  (Rp 280000)"
    echo "3. Futsal   (Rp 300000)"
    echo "4. Basket   (Rp 450000)"
    echo "-----------------------------------"
    read -p "Masukkan pilihan (1-4): " pilih

    case $pilih in
        1) TIPE_SEPATU="Sneaker"; HARGA_SEPATU=350000 ;;
        2) TIPE_SEPATU="Running"; HARGA_SEPATU=280000 ;;
        3) TIPE_SEPATU="Futsal"; HARGA_SEPATU=300000 ;;
        4) TIPE_SEPATU="Basket"; HARGA_SEPATU=450000 ;;
        *) echo -e "${RED}Pilihan tidak valid!${RESET}"; return 1 ;;
    esac

    return 0
}

add_transaksi() {
    header
    read -p "Masukkan nama pembeli: " nama
    validate_not_empty "$nama" || return

    pilih_tipe || return

    read -p "Masukkan jumlah pembelian: " jumlah
    if ! [[ $jumlah =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Jumlah harus berupa angka!${RESET}"
        return
    fi

    total=$((jumlah * HARGA_SEPATU))

    NAMA+=("$nama")
    TIPE+=("$TIPE_SEPATU")
    HARGA+=("$HARGA_SEPATU")
    JUMLAH+=("$jumlah")
    TOTAL+=("$total")

    echo -e "${GREEN}Transaksi berhasil ditambahkan!${RESET}"
}

show_transaksi() {
    header
    if [ ${#NAMA[@]} -eq 0 ]; then
        echo -e "${YELLOW}Belum ada transaksi.${RESET}"
        return
    fi

    echo -e "${GREEN}Daftar Transaksi:${RESET}"
    echo "--------------------------------------------------------------"
    for i in "${!NAMA[@]}"; do
        echo -e "$((i+1)). Nama   : ${NAMA[$i]}"
        echo -e "    Tipe   : ${TIPE[$i]}"
        echo -e "    Harga  : Rp ${HARGA[$i]}"
        echo -e "    Jumlah : ${JUMLAH[$i]}"
        echo -e "    Total  : ${TOTAL[$i]}"
        echo "--------------------------------------------------------------"
    done
}

delete_transaksi() {
    index=$1

    if [ -z "$index" ] || ! [[ $index =~ ^[0-9]+$ ]]; then
        echo -e "${RED}Input harus angka!${RESET}"
        return
    fi

    if [ $index -le 0 ] || [ $index -gt ${#NAMA[@]} ]; then
        echo -e "${RED}Nomor transaksi tidak valid!${RESET}"
        return
    fi

    unset NAMA[$((index-1))]
    unset TIPE[$((index-1))]
    unset HARGA[$((index-1))]
    unset JUMLAH[$((index-1))]
    unset TOTAL[$((index-1))]

    NAMA=("${NAMA[@]}")
    TIPE=("${TIPE[@]}")
    HARGA=("${HARGA[@]}")
    JUMLAH=("${JUMLAH[@]}")
    TOTAL=("${TOTAL[@]}")

    echo -e "${GREEN}Transaksi berhasil dihapus!${RESET}"
}

stats() {
    total_transaksi=${#NAMA[@]}
    total_uang=0

    for t in "${TOTAL[@]}"; do
        total_uang=$((total_uang + t))
    done

    echo -e "${CYAN}Jumlah Transaksi : $total_transaksi${RESET}"
    echo -e "${GREEN}Total Pendapatan : Rp $total_uang${RESET}"
}

while true; do
    header
    echo "1. Tambah Transaksi"
    echo "2. Lihat Semua Transaksi"
    echo "3. Hapus Transaksi"
    echo "4. Statistik Penjualan"
    echo "0. Keluar"
    echo "---------------------------------------"
    read -p "Pilih menu: " menu

    case $menu in
        1) add_transaksi ;;
        2) show_transaksi ;;
        3)
            show_transaksi
            read -p "Masukkan nomor transaksi yang ingin dihapus: " no
            delete_transaksi "$no"
            ;;
        4) stats ;;
        0)
            echo -e "${GREEN}Terima kasih telah menggunakan aplikasi!${RESET}"
            exit 0 ;;
        *)
            echo -e "${RED}Pilihan tidak valid!${RESET}" ;;
    esac

    echo
    read -p "Tekan ENTER untuk melanjutkan..."
done
