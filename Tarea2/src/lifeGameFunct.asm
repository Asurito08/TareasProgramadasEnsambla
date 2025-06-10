; lifeGameFunct.asm
; Función: void iterarMatriz(char *matriz, char *matrizSiguiente)
;   - rdi = puntero matriz original
;   - rsi = puntero matriz siguiente

section .text
global iterarMatriz

%define FILAS 20
%define COLUMNAS 20

iterarMatriz:
    push rbp
    mov rbp, rsp
    push rbx
    push r12
    push r13
    push r14
    push r15

    mov r15, rdi        ; matriz original
    mov r14, rsi        ; matriz siguiente

    xor r12, r12        ; fila = 0

fila_loop:
    cmp r12, FILAS
    jge fin_filas

    xor r13, r13        ; col = 0

col_loop:
    cmp r13, COLUMNAS
    jge fin_col

    ; Contar vecinos vivos (valor '1')
    mov rbx, 0          ; contador vecinos = 0

    ; Recorremos vecinos: dr = -1..1, dc = -1..1
    mov rdx, -1

dr_loop:
    cmp rdx, 2
    jge fin_dr

    mov rcx, -1

dc_loop:
    cmp rcx, 2
    jge fin_dc

    ; ignorar la celda misma (dr == 0 and dc == 0)
    cmp rdx, 0
    jne check_pos
    cmp rcx, 0
    je skip_cell

check_pos:
    ; calcular fila vecina = fila + dr
    mov r8, r12
    add r8, rdx

    ; calcular col vecina = col + dc
    mov r9, r13
    add r9, rcx

    ; verificar límites (0 <= fila < FILAS)
    cmp r8, 0
    jl skip_cell
    cmp r8, FILAS
    jge skip_cell

    cmp r9, 0
    jl skip_cell
    cmp r9, COLUMNAS
    jge skip_cell

    ; calcular offset = fila_vecina * COLUMNAS + col_vecina
    mov r10, r8
    imul r10, COLUMNAS
    add r10, r9

    ; cargar valor matriz[r10]
    mov al, byte [r15 + r10]
    cmp al, '1'
    jne skip_cell

    inc rbx

skip_cell:
    inc rcx
    jmp dc_loop

fin_dc:
    inc rdx
    jmp dr_loop

fin_dr:

    ; Ahora rbx tiene el número de vecinos vivos

    ; cargar valor celda actual matriz original
    mov r10, r12
    imul r10, COLUMNAS
    add r10, r13
    mov al, byte [r15 + r10]

    ; Aplicar reglas del Juego de la Vida
    ; Regla estándar:
    ; Si celda viva ('1'):
    ;    - con 2 o 3 vecinos vivos sobrevive
    ;    - si no, muere (0)
    ; Si celda muerta ('0'):
    ;    - con exactamente 3 vecinos vivos nace (1)
    ;    - si no, sigue muerta (0)

    cmp al, '1'
    jne celda_muerta

    ; celda viva:
    cmp rbx, 2
    je sobrevive
    cmp rbx, 3
    je sobrevive
    ; muere
    mov al, '0'
    jmp guardar

sobrevive:
    mov al, '1'
    jmp guardar

celda_muerta:
    cmp rbx, 3
    jne sigue_muerta
    mov al, '1'
    jmp guardar

sigue_muerta:
    mov al, '0'

guardar:
    ; Guardar resultado en matrizSiguiente
    mov r11, r12
    imul r11, COLUMNAS
    add r11, r13
    mov byte [r14 + r11], al

    inc r13
    jmp col_loop

fin_col:
    inc r12
    jmp fila_loop

fin_filas:
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    mov rsp, rbp
    pop rbp
    ret
