section .data
    nombreArchivo db "data/datos.txt", 0
    filas equ 20
    columnas equ 50
    bytesTotales equ filas * (columnas+1)

    limpiarPantalla db 27, '[', '2', 'J', 27, '[', 'H' ; Secuencia ANSI para limpiar pantalla
    limpiarLen equ $ - limpiarPantalla

    ; Indicaciones para esperar
    timespec:
        dq 0
        dq 100000000

section .bss
    matriz resb bytesTotales
    matrizSiguiente resb bytesTotales

section .text
    global _start

_start:
    xor r8, r8 ; Índice para el bucle

    ;Abrir archivo
    mov rax, 2
    mov rdi, nombreArchivo
    xor rsi, rsi
    xor rdx, rdx
    syscall
    mov r12, rax

    ; Leer archivo
    mov rax, 0
    mov rdi, r12
    mov rsi, matriz
    mov rdx, bytesTotales
    syscall

    ; Cerrar archivo
    mov rax, 3
    mov rdi, r12
    syscall

    mov rsi, matriz
    mov rdi, matrizSiguiente
    mov rcx, bytesTotales
    rep movsb

    bucle:
        
        ; Limpiar pantalla con ANSI
        mov rax, 1
        mov rdi, 1
        mov rsi, limpiarPantalla
        mov rdx, limpiarLen
        syscall

        ; Imprimir matriz
        mov rax, 1
        mov rdi, 1
        mov rsi, matriz
        mov rdx, bytesTotales
        syscall

        ; Esperar
        mov rax, 35
        lea rdi, [timespec]
        xor rsi, rsi
        syscall

        xor rbp, rbp ; Índice para recorrer filas
        recorrerFilas:
            cmp rbp, filas ; Verificar si sigue en rango
            jge continuar

            xor rbx, rbx ; Índice para recorrer columnas
            recorrerColumnas:
                cmp rbx, columnas ; Verificar si sigue en rango
                jge continuarRecorrerFilas

                imul rdx, rbp, columnas+1
                add rdx, rbx ; Índice total

                xor r9, r9 ; Contador de vecinos
                
                xor r12, r12
                xor r10, r10
                add r10, -1 ; Índice para recorrer vecinos (filas)
                recorrerVecinosFila:
                    cmp r10, 1
                    jg continuarVecinos

                    mov r12, rbp
                    add r12, r10 ; Y de vecino

                    xor r11, r11
                    add r11, -1 ; Índice para recorrer vecinos (columnas)
                    recorrerVecinosColumna:
                        cmp r11, 1
                        jg continuarVecinosFila

                        mov r13, rbx
                        add r13, r11 ; X de vecino

                        inc r11 ; Incrementar contador de vecinos columna

                        ; Verificar 0 <= Y < filas
                        cmp r12, 0
                        jl recorrerVecinosColumna
                        cmp r12, filas
                        jge recorrerVecinosColumna 
                    
                        ; Verificar 0 <= x < columnas
                        cmp r13, 0
                        jl recorrerVecinosColumna
                        cmp r13, columnas
                        jge recorrerVecinosColumna

                        ; Calcular índice total
                        imul r14, r12, columnas+1
                        add r14, r13

                        ; Verificar que no sea uno mismo
                        cmp r14, rdx
                        je recorrerVecinosColumna

                        ; Verificar si está viva
                        mov rax, matriz
                        add rax, r14
                        cmp byte [rax], '1'
                        je incrementarVecinos

                        jmp recorrerVecinosColumna

                        incrementarVecinos: ; Incrementar vecinos si alguno está vivo
                            inc r9
                            jmp recorrerVecinosColumna

                        continuarVecinosFila: ; Incrementar el contador de vecinos fila
                            inc r10
                            jmp recorrerVecinosFila

                    continuarVecinos:

                        lea rdi, [matrizSiguiente]
                        add rdi, rdx

                        cmp r9, 2
                        jl cero
                        je saltar
                        
                        cmp r9, 3
                        je uno
                        jg cero

                        cero:
                            mov byte [rdi], '0'
                            jmp saltar

                        uno:
                            mov byte [rdi], '1'
                            jmp saltar

                        saltar:
                            inc rbx ; Incrementar contador de columnas
                            jmp recorrerColumnas

                continuarRecorrerFilas:
                    inc rbp ; Incrementar contador de filas
                    jmp recorrerFilas
            continuar:
                inc r8 ; Incrementar contador del bucle
                cmp r8, 1000
                je salir
                mov rsi, matrizSiguiente
                mov rdi, matriz
                mov rcx, bytesTotales
                rep movsb
                jmp bucle

                salir:
                    mov rax, 60
                    xor rdi, rdi
                    syscall

                    