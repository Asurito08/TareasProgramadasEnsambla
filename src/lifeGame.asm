section .data
    char db 0
    archivoNombre db "data/datos.txt", 0         ; nombre del archivo
    filas         equ 30
    columnas      equ 75
    totalBytes    equ filas * (columnas + 1)     ; 5 × 6 = 30

    ; Secuencia ANSI para limpiar pantalla y mover el cursor al inicio
    clear_screen db 27, '[', '2', 'J', 27, '[', 'H'  ; "\033[2J\033[H"
    clear_len    equ $ - clear_screen

    ; Tiempo para nanosleep
    timespec:
        dq 0            ; segundos
        dq 100000000    ; nanosegundos (0.1s)

section .bss
    matriz resb totalBytes

section .text
    global _start

_start:
    xor r8, r8 ; contador de iteraciones

    ; Abrir el archivo
    mov     rax, 2
    mov     rdi, archivoNombre
    xor     rsi, rsi
    xor     rdx, rdx
    syscall
    mov     r12, rax

    ; Leer el archivo
    mov     rax, 0
    mov     rdi, r12
    mov     rsi, matriz
    mov     rdx, totalBytes
    syscall

    ; Cerrar el archivo
    mov     rax, 3
    mov     rdi, r12
    syscall

bucle:
    ; Limpiar pantalla con ANSI escape
    ; mov     rax, 1
    ; mov     rdi, 1
    ; mov     rsi, clear_screen
    ; mov     rdx, clear_len
    ; syscall

    ; Imprimir la matriz
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, matriz
    mov     rdx, totalBytes
    syscall

    ; Esperar un poco (nanosleep)
    mov     rax, 35         ; syscall 35 = nanosleep
    lea     rdi, [timespec] ; tiempo solicitado
    xor     rsi, rsi        ; tiempo restante (NULL)
    syscall

    xor rcx, rcx ; indice para las filas
    add rcx, -1
    recorrerFilas:
        cmp rcx, filas
        jge continuar
        inc rcx

        xor rbx, rbx ; indice para las columnas
        recorrerColumnas:
            cmp rbx, columnas
            je recorrerFilas

            mov rax, rcx
            imul rdx, rax, columnas + 1
            add rdx, rbx ; indice total

            xor r9, r9 ; contador de vecinos

            mov r10, -1 ; indice vecinos fila
            recorrerVecinosFila:
                cmp r10, 1
                jg continuarVecinos

                mov r15, r10

                inc r10

                mov r11, -1 ; indice vecinos columna
                recorrerVecinosColumna:
                    cmp r11, 1
                    jg recorrerVecinosFila

                    mov r12, rcx
                    add r12, r15 ; Y de vecino
                    mov r13, rbx
                    add r13, r11 ; X de vecino

                    inc r11

                    cmp r12, 0
                    jb recorrerVecinosColumna
                    cmp r12, filas
                    jg recorrerVecinosColumna

                    cmp r13, 0
                    jb recorrerVecinosColumna
                    cmp r13, columnas
                    jg recorrerVecinosColumna

                    mov r14, r12
                    mov rax, r12
                    imul r14, rax, columnas + 1
                    add r14, r13

                    cmp r14, rdx
                    je recorrerVecinosColumna

                    mov rax, matriz
                    add rax, r14
                    cmp byte [rax], '1' ; Verificar si la celda está viva
                    je incrementarVecinos

                    jmp recorrerVecinosColumna

                    incrementarVecinos:
                        inc r9
                        jmp recorrerVecinosColumna

            continuarVecinos:

            add r9b, '0'
            mov [char], r9b

            mov rax, 1
            mov rdi, 1
            mov rsi, char
            mov rdx, 1
            syscall

            inc rbx
            jmp recorrerColumnas

    continuar:
    inc r8
    cmp r8, 1             ; Repetir X veces (por ejemplo, 10 veces)
    je salir
    jmp bucle

    salir:
    mov     rax, 60
    xor     rdi, rdi
    syscall
