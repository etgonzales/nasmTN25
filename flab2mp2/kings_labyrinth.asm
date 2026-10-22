section .data
    title db 10,'========================================',10,"        THE KING'S LABYRINTH",10,'========================================',10,'             |>>>>',10,'          ___|___',10,'         |  _ _  |',10,'         | |   | |',10,'         |_|___|_|',10,'           |   |',10,'          _|___|_',10,'        ENTER IF YOU DARE!',10,0
    ask_name db 10,'Enter your hero name: ',0
    ask_class db 10,'Choose your character:',10,'[1] Brawler',10,'[2] Archer (Scout)',10,'[3] Bard',10,'Enter choice: ',0
    invalid db 'Invalid selection. Try again.',10,0
    welcome db 10,'Welcome, ',0
    the_word db ' the ',0
    brawler db 'Brawler',0
    scout db 'Scout',0
    bard db 'Bard',0
    bang db '!',10,0
    menu db 10,'========== MAIN MENU ==========',10,'[1] Explore Dungeon',10,'[2] View Character Status',10,'[3] Use Health Potion',10,'[4] View Inventory',10,'[5] Exit Game',10,'Enter choice: ',0
    status_head db 10,'========== HERO STATUS ==========',10,'Hero: ',0
    inventory_head db 10,'========== INVENTORY ==========',10,0
    health_msg db 'Health: ',0
    max_msg db ' / ',0
    attack_msg db 'Attack: ',0
    potion_msg db 'Potions: ',0
    gold_msg db 'Gold: ',0
    room_msg db 'Next room: ',0
    newline db 10,0
    no_potions db 'No potions remaining!',10,0
    healed db 'Potion used. Restored up to 20 health.',10,0
    room1 db 10,'=== ROOM 1: THE FORGOTTEN CHAMBER ===',10,'  .-.',10,' (o o)  SKELETON GUARDIAN!',10,'  | |',10,0
    room2 db 10,'=== ROOM 2: THE ROYAL TREASURY ===',10,'  __________',10,' /_________/|',10,' |  GOLD   | |',10,' |_________|/',10,'[1] Open Chest',10,'[2] Leave Chest',10,'Enter choice: ',0
    room3 db 10,"=== ROOM 3: THE FALLEN KING'S THRONE ===",10,'   /\___/\',10,'  ( x   x )  THE FALLEN KING!',10,'   \_===_/',10,0
    chest_gold db 'You found 50 gold!',10,0
    chest_leave db 'You leave the chest untouched.',10,0
    combat_menu db 10,'[1] Attack',10,'[2] Defend',10,'[3] Use Potion',10,'[4] Run',10,'Enter choice: ',0
    combat_divider db 10,'************************************',10,10,0
    enemy_health_msg db 'Enemy health: ',0
    your_health_msg db 'Your health: ',0
    attack_text db 'You attack!',10,0
    defend_text db 'You defend!',10,0
    enemy_text db 'Enemy attacks! Damage taken: ',0
    enemy_defeated db 10,'Enemy defeated! Room cleared.',10,0
    ran_text db 10,'You escaped! Room progress unchanged.',10,0
    victory db 10,'************ VICTORY! ************',10,'You defeated the Fallen King!',10,'Congratulations, ',0
    hero_text db '! YOU ARE A LEGEND!',10,0
    final_gold db 'Final Gold: ',0
    final_health db 'Remaining Health: ',0
    gameover db 10,'************ GAME OVER ************',10,'Your hero has fallen.',10,'The labyrinth remains undefeated.',10,0
    goodbye db "Thanks for playing The King's Labyrinth!",10,0
    zero dd 0

section .bss
    hero_name resb 64
    input resb 64
    hero_class resd 1
    hp resd 1
    max_hp resd 1
    atk resd 1
    potions resd 1
    gold resd 1
    room resd 1
    enemy_hp resd 1
    enemy_damage resd 1
    number_buf resb 16
    one_char resb 1

section .text
    global _start

; print a zero-terminated string whose address is in ECX
print_string:
    push eax
    push ebx
    push edx
    push esi
    mov esi, ecx
    xor edx, edx
.count:
    cmp byte [esi+edx], 0
    je .write
    inc edx
    jmp .count
.write:
    mov eax, 4
    mov ebx, 1
    int 0x80
    pop esi
    pop edx
    pop ebx
    pop eax
    ret

; read a line into input (max 63 bytes), remove newline
read_input:
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 63
    int 0x80
    cmp eax, 0
    jle exit_program
    mov esi, input
    mov ecx, eax
    xor edx, edx
.scan:
    cmp edx, ecx
    jae .terminate
    cmp byte [esi+edx], 10
    je .terminate
    inc edx
    jmp .scan
.terminate:
    mov byte [esi+edx], 0
    ret

; get a one-digit choice; 0 means invalid
read_choice:
    call read_input
    cmp byte [input+1], 0
    jne .invalid
    mov al, [input]
    cmp al, '0'
    jb .invalid
    cmp al, '9'
    ja .invalid
    sub al, '0'
    movzx eax, al
    ret
.invalid:
    xor eax, eax
    ret

; print unsigned integer EAX
print_number:
    push eax
    push ebx
    push ecx
    push edx
    push edi
    mov edi, number_buf+15
    mov byte [edi], 0
    mov ebx, 10
.repeat:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz .repeat
    mov ecx, edi
    call print_string
    pop edi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

print_line:
    mov ecx, newline
    call print_string
    ret

print_invalid:
    mov ecx, invalid
    call print_string
    ret

display_welcome:
    mov ecx, title
    call print_string
    ret

get_player_info:
    mov ecx, ask_name
    call print_string
    call read_input
    mov esi, input
    mov edi, hero_name
    mov ecx, 64
    cld
    rep movsb
.select:
    mov ecx, ask_class
    call print_string
    call read_choice
    cmp eax, 1
    jb .bad
    cmp eax, 3
    ja .bad
    mov [hero_class], eax
    call initialize_character
    mov ecx, welcome
    call print_string
    mov ecx, hero_name
    call print_string
    mov ecx, the_word
    call print_string
    call print_class
    mov ecx, bang
    call print_string
    call display_status
    ret
.bad:
    call print_invalid
    jmp .select

initialize_character:
    mov dword [gold], 0
    mov dword [room], 1
    cmp dword [hero_class], 1
    je .brawler
    cmp dword [hero_class], 2
    je .scout
    mov dword [max_hp], 80
    mov dword [atk], 15
    mov dword [potions], 4
    jmp .finish
.brawler:
    mov dword [max_hp], 120
    mov dword [atk], 20
    mov dword [potions], 2
    jmp .finish
.scout:
    mov dword [max_hp], 90
    mov dword [atk], 25
    mov dword [potions], 2
.finish:
    mov eax, [max_hp]
    mov [hp], eax
    ret

print_class:
    cmp dword [hero_class], 1
    je .brawler
    cmp dword [hero_class], 2
    je .scout
    mov ecx, bard
    jmp print_string
.brawler:
    mov ecx, brawler
    jmp print_string
.scout:
    mov ecx, scout
    jmp print_string

display_status:
    mov ecx, status_head
    call print_string
    mov ecx, hero_name
    call print_string
    mov ecx, the_word
    call print_string
    call print_class
    call print_line
    mov ecx, health_msg
    call print_string
    mov eax, [hp]
    call print_number
    mov ecx, max_msg
    call print_string
    mov eax, [max_hp]
    call print_number
    call print_line
    mov ecx, attack_msg
    call print_string
    mov eax, [atk]
    call print_number
    call print_line
    mov ecx, potion_msg
    call print_string
    mov eax, [potions]
    call print_number
    call print_line
    mov ecx, room_msg
    call print_string
    mov eax, [room]
    call print_number
    call print_line
    ret

display_inventory:
    mov ecx, inventory_head
    call print_string
    mov ecx, gold_msg
    call print_string
    mov eax, [gold]
    call print_number
    call print_line
    mov ecx, potion_msg
    call print_string
    mov eax, [potions]
    call print_number
    call print_line
    ret

use_potion:
    cmp dword [potions], 0
    jle .empty
    dec dword [potions]
    add dword [hp], 20
    mov eax, [max_hp]
    cmp [hp], eax
    jle .done
    mov [hp], eax
.done:
    mov ecx, healed
    call print_string
    ret
.empty:
    mov ecx, no_potions
    call print_string
    ret

display_main_menu:
    mov ecx, menu
    call print_string
    ret

explore_dungeon:
    cmp dword [room], 1
    je .first
    cmp dword [room], 2
    je .second
    cmp dword [room], 3
    je .third
    ret
.first:
    mov ecx, room1
    call print_string
    mov dword [enemy_hp], 30
    mov dword [enemy_damage], 10
    call battle_enemy
    cmp eax, 1
    jne .done
    inc dword [room]
    ret
.second:
    mov ecx, room2
    call print_string
.chest_choice:
    call read_choice
    cmp eax, 1
    je .open_chest
    cmp eax, 2
    je .leave_chest
    call print_invalid
    mov ecx, room2
    call print_string
    jmp .chest_choice
.open_chest:
    add dword [gold], 50
    mov ecx, chest_gold
    call print_string
    inc dword [room]
    ret
.leave_chest:
    mov ecx, chest_leave
    call print_string
    inc dword [room]
    ret
.third:
    mov ecx, room3
    call print_string
    mov dword [enemy_hp], 80
    mov dword [enemy_damage], 15
    call battle_enemy
    cmp eax, 1
    jne .done
    inc dword [room]
    call display_game_result
.done:
    ret

; Returns EAX=1 on win, EAX=0 on run. Death exits game.
battle_enemy:
    ; Show the starting health once before the first combat choice.
    call .show_health
.loop:
    mov ecx, combat_menu
    call print_string
    call read_choice
    cmp eax, 1
    je .attack
    cmp eax, 2
    je .defend
    cmp eax, 3
    je .potion
    cmp eax, 4
    je .run
    call print_line
    call print_invalid
    jmp .loop
.attack:
    call .separator
    mov ecx, attack_text
    call print_string
    mov eax, [atk]
    sub [enemy_hp], eax
    cmp dword [enemy_hp], 0
    jle .win
    mov eax, [enemy_damage]
    jmp .retaliate
.defend:
    call .separator
    mov ecx, defend_text
    call print_string
    mov eax, [enemy_damage]
    sub eax, 5
    jns .retaliate
    xor eax, eax
.retaliate:
    ; Keep damage in EAX while printing the message.
    mov ecx, enemy_text
    call print_string
    call print_number
    call print_line
    sub [hp], eax
    cmp dword [hp], 0
    jg .after_turn
    mov dword [hp], 0
    call .show_health_lines
    call .separator
    call display_game_result
    jmp exit_program
.potion:
    call .separator
    call use_potion
.after_turn:
    call .show_health_lines
    call .separator
    jmp .loop
.run:
    call .separator
    mov ecx, ran_text
    call print_string
    xor eax, eax
    ret
.win:
    mov dword [enemy_hp], 0
    call .show_health_lines
    call .separator
    mov ecx, enemy_defeated
    call print_string
    mov eax, 1
    ret
.separator:
    mov ecx, combat_divider
    call print_string
    ret
.show_health:
    call .show_health_lines
    call .separator
    ret
.show_health_lines:
    mov ecx, enemy_health_msg
    call print_string
    mov eax, [enemy_hp]
    call print_number
    call print_line
    mov ecx, your_health_msg
    call print_string
    mov eax, [hp]
    call print_number
    call print_line
    ret

display_game_result:
    cmp dword [hp], 0
    jle .lost
    mov ecx, victory
    call print_string
    mov ecx, hero_name
    call print_string
    mov ecx, hero_text
    call print_string
    mov ecx, final_gold
    call print_string
    mov eax, [gold]
    call print_number
    call print_line
    mov ecx, final_health
    call print_string
    mov eax, [hp]
    call print_number
    call print_line
    jmp exit_program
.lost:
    mov ecx, gameover
    call print_string
    ret

exit_program:
    mov eax, 1
    xor ebx, ebx
    int 0x80

_start:
    call display_welcome
    call get_player_info
.main_loop:
    call display_main_menu
    call read_choice
    cmp eax, 1
    je .explore
    cmp eax, 2
    je .status
    cmp eax, 3
    je .potion
    cmp eax, 4
    je .inventory
    cmp eax, 5
    je .exit
    call print_invalid
    jmp .main_loop
.explore:
    call explore_dungeon
    jmp .main_loop
.status:
    call display_status
    jmp .main_loop
.potion:
    call print_line
    call use_potion
    jmp .main_loop
.inventory:
    call display_inventory
    jmp .main_loop
.exit:
    mov ecx, goodbye
    call print_string
    call exit_program
