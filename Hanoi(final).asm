    .text
main:
    addi  s0, zero, 3            # Para almacenar el número de discos
    lui   s1, 0x100e0            # Dirección de memoria donde se guarda
    addi  s1, s1, 0x0            # Dirección de source[]
    addi  s2, s1, 0x4            # Dirección de aux[]
    addi  s3, s1, 0x8            # Dirección de dest[]
    addi  s4, s1, 0x0            # Copia de la dirección de source[]
    addi  s5, s1, 0x4            # Copia de la dirección de aux[]
    addi  s6, s1, 0x8            # Copia de la dirección de dest[]

    add   a1, zero, s0           # Número de discos en source[]
    add   a2, zero, zero         # 0 discos en aux[]
    add   a3, zero, zero         # 0 discos en dest[]
    add   a4, zero, zero         # Inicialización en source
    add   a5, zero, zero         # Inicialización en dest
    addi  t0, zero, 32           # Variable para el movimiento vertical
    add   t1, zero, s1           # Posición de origen

In_torre:
    bge   a0, s0, Fin_torre      # Si a0 >= s0, entonces fin de In_tower
    addi  t2, a0, 1              # t2 = a0 + 1 (número del disco)
    sw    t2, (t1)               # Almacena el número del disco en source[]
    add   t1, t1, t0             # Mueve a la siguiente posición en source[]
    addi  a0, a0, 1              # Incrementa a0 (contador)
    jal   In_torre               # Ciclo para inicializar la torre

Fin_torre:
# Declarar variable para comparar en el caso base para la función Hanoi
    addi  t3, zero, 1            # t3 = 1
    jal   Hanoi                  # Llama a la función hanoi
    jal   end                    # Llama a la función end

Hanoi:
# Caso base si n == 1
    bne   a0, t3, hanoi_recursivo # Si n != 1, entonces hanoi_recursivo
                                  # Si n == 1, ejecutar mover
mover:
    jal   s8, swap               # Llama a la función swap y guarda ra en s8
# Calcula la posición en source[]
    sub   t1, s0, a4             # t1 = s0 - a4
    slli  t1, t1, 5              # t1 = t1 * 32 para obtener la posición de source[]
    add   t1, s4, t1             # t1 = s4 + t1, almacena la dirección de source[]
    lw    t2, (t1)               # t2 = source[t1], obtiene el disco de source[]
    sw    zero, (t1)             # source[t1] = 0, elimina el disco de source[]

    sub   t1, s0, a5             # t1 = s0 - a5
    addi  t1, t1, -1             # t1 = s0 - a5 - 1
    slli  t1, t1, 5              # t1 = t1 * 32 para obtener la posición de dest[]
    add   t1, s6, t1             # t1 = s6 + t1, almacena la dirección de dest[]
    sw    t2, (t1)               # dest[t1] = t2, almacena el disco en dest[]
    jalr  ra                     # Retorna

swap:
    beq   s4, s1, case_1         # Si s4 == source[], entonces case_1
    beq   s4, s2, case_2         # Si s4 == aux[], entonces case_2
    beq   s4, s3, case_3         # Si s4 == dest[], entonces case_3

case_1:
    add   a4, zero, a1           # Copia el número de discos en source[] a a4
    addi  a1, a1, -1             # Decrementa el número de discos en source[]
    jal   zero, swap_fin         # Retorna a swap_end

case_2:
    add   a4, zero, a2           # a4 -> aux[]
    addi  a2, a2, -1             # Decrementa el número de discos en aux[]
    jal   zero, swap_fin       # Retorna a swap_end

case_3:
    add   a4, zero, a3           # Copia el número de discos en dest[] a a4
    addi  a3, a3, -1             # Decrementa el número de discos en dest[]
    jal   zero, swap_fin        # Retorna a swap_end

swap_fin:
    beq   s6, s1, fin_1     # Si s6 == source[]
    beq   s6, s2, fin_2     # Si s6 == aux[}
    beq   s6, s3, fin_3     # Si s6 == dest[]

fin_1:
    add   a5, zero, a1           # Copia el número de discos en source[] a a6
    addi  a1, a1, 1              # Incrementa el número de discos en source[]
    jalr  zero, s8, 0            # Retorna a s8

fin_2:
    add   a5, zero, a2           # Copia el número de discos en aux[] a a6
    addi  a2, a2, 1              # Incrementa el número de discos en aux[]
    jalr  zero, s8, 0            # Retorna a s8

fin_3:
    add   a5, zero, a3           # Copia el número de discos en dest[] a a6
    addi  a3, a3, 1              # Incrementa el número de discos en dest[]
    jalr  zero, s8, 0            # Retorna a s8

hanoi_recursivo:
# Empuja a0, s4, s5, s6, ra
    addi  sp, sp, -20
    sw    a0, 0(sp)              # Empuja a0
    sw    s4, 4(sp)              # Empuja s4
    sw    s5, 8(sp)              # Empuja s5
    sw    s6, 12(sp)             # Empuja s6
    sw    ra, 16(sp)             # Empuja ra

# Modificar argumentos
    addi  a0, a0, -1             # a0 -> n - 1
    add   t2, s5, zero           # t2 -> aux[]
    add   s5, s6, zero           # aux[] -> dest[]
    add   s6, t2, zero           # dest[] -> aux[]

# Hanoi(n-1, source[], aux[], dest[])
    jal   Hanoi                  # Llama a la recursión

# Saca ra, s6, s5, s4, a0
    lw    ra, 16(sp)             # Saca ra
    lw    s6, 12(sp)             # Saca s6
    lw    s5, 8(sp)              # Saca s5
    lw    s4, 4(sp)              # Saca s4
    lw    a0, 0(sp)              # Saca a0
    addi  sp, sp, 20
    jal   s9, mover_2       # Llama a innit_move_2

# Segunda recursión
# Empuja a0, s4, s5, s6, ra
    addi  sp, sp, -20
    sw    a0, 0(sp)              # Empuja a0
    sw    s4, 4(sp)              # Empuja s4
    sw    s5, 8(sp)              # Empuja s5
    sw    s6, 12(sp)             # Empuja s6
    sw    ra, 16(sp)             # Empuja ra

# Modificar argumentos
    addi  a0, a0, -1             # a0 -> n - 1
    add   t2, s4, zero           # t2 -> source[]
    add   s4, s5, zero           # source[] -> aux[]
    add   s5, t2, zero           # aux[] -> source[]
# Llama a la recursión
    jal   Hanoi                  # Llama a hanoi(n-1, aux[], source[], dest[])

# Saca ra, s6, s5, s4, a0
    lw    ra, 16(sp)             # Saca ra
    lw    s6, 12(sp)             # Saca s6
    lw    s5, 8(sp)              # Saca s5
    lw    s4, 4(sp)              # Saca s4
    lw    a0, 0(sp)              # Saca a0
    addi  sp, sp, 20
    jalr  ra                     # Retorna

mover_2:
    jal   s10, swap_2            # Llama a swap y guarda ra en s10
# Calcula la posición en source[]
    sub   t1, s0, a4             # t1 = s0 - a4
    slli  t1, t1, 5              # t1 = t1 * 32 para obtener la posición de source[]
    add   t1, s4, t1             # t1 = s4 + t1, almacena la dirección de source[]
    lw    t2, (t1)               # t2 = source[t1], obtiene el disco de source[]
    sw    zero, (t1)             # source[t1] = 0, elimina el disco de source[]

    sub   t1, s0, a5             # t1 = s0 - a5
    addi  t1, t1, -1             # t1 = s0 - a5 - 1
    slli  t1, t1, 5              # t1 = t1 * 32 para obtener la posición de dest[]
    add   t1, s6, t1             # t1 = s6 + t1, almacena la dirección de dest[]
    sw    t2, (t1)               # dest[t1] = t2, almacena el disco en dest[]
    jalr  zero, s9, 0            # Retorna a s9

swap_2:
    beq   s4, s1, case_1_        # Si s4 == source[], entonces case_1
    beq   s4, s2, case_2_        # Si s4 == aux[], entonces case_2
    beq   s4, s3, case_3_        # Si s4 == dest[], entonces case_3

case_1_:
    add   a4, zero, a1           # Copia el número de discos en source[] a a4
    addi  a1, a1, -1             # Decrementa el número de discos en source[]
    jal   zero, swap_end_2       # Retorna a swap_end

case_2_:
    add   a4, zero, a2           # source[] -> aux[]
    addi  a2, a2, -1             # Decrementa el número de discos en aux[]
    jal   zero, swap_end_2       # Retorna a swap_end

case_3_:
    add   a4, zero, a3           # Copia el número de discos en dest[] a a4
    addi  a3, a3, -1             # Decrementa el número de discos en dest[]
    jal   zero, swap_end_2       # Retorna a swap_end

swap_end_2:
    beq   s6, s1, end_siguiente_1     # Si s6 == source[], entonces end_swap_1
    beq   s6, s2, end_siguiente_2    # Si s6 == aux[], entonces end_swap_2
    beq   s6, s3, end_siguiente_3     # Si s6 == dest[], entonces end_swap_3

end_siguiente_1:
    add   a5, zero, a1           # Copia el número de discos en source[] a a6
    addi  a1, a1, 1              # Incrementa el número de discos en source[]
    jalr  zero, s10, 0           # Retorna a s10

end_siguiente_2:
    add   a5, zero, a2           # Copia el número de discos en aux[] a a6
    addi  a2, a2, 1              # Incrementa el número de discos en aux[]
    jalr  zero, s10, 0           # Retorna a s10

end_siguiente_3:
    add   a5, zero, a3           # Copia el número de discos en dest[] a a6
    addi  a3, a3, 1              # Incrementa el número de discos en dest[]
    jalr  zero, s10, 0           # Retorna a s10

end: j end                         # Fin del programa
