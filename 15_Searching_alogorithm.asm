.model small
.stack 100h
.data                           

str db 10,13,"Enter Values: $"
str1 db 0dh,0ah,"Bubble Sorted: $"
array db 10 dup(?)
len dw 10                 ; length of the array
msg db 10,13,"Enter Number $"
msg1 db 10,13, "number is Found  $"
msg2 db 10,13, "number is not Found $"
msg3 db 10,13, "Smallest Value: $"
msg4 db 10,13, "Largest Value: $"
key equ 33h    ;key value for comparison

.code 
  ; Sorting array (bubble sorting)
  mov ax, @data
  mov ds, ax 
  mov ah, 9
  lea dx, str
  int 21h

  mov cx, 10
  mov bx, offset array ; Marking index

inputs:
  mov ah, 1
  int 21h
  mov [bx], al    ; Storing char into array 
  inc bx         ; Inc index
  loop inputs

  mov cx, 10
  dec cx

nextscan:
  mov bx, cx
  mov si, 0

nextcomp:
  mov al, array[si]
  mov dl, array[si + 1]
  cmp al, dl
  jc noswap      ; Jump to noswap if al < dl

  mov array[si], dl      ; Swap the values
  mov array[si + 1], al

noswap:
  inc si
  dec bx
  jnz nextcomp       ; Repeat comparison until end of array
  loop nextscan      ; Repeat the sorting process

  ; Print the sorted array
  mov ah, 9
  lea dx, str1
  int 21h

  mov cx, 10
  mov bx, offset array

print:
  mov ah, 2
  mov dl, [bx]
  int 21h
  inc bx
  loop print
  
  
  
  ; Find and print the smallest value
  mov si, offset array
  mov cx, 10
  mov bl, [si]
  mov si, offset array ; Reset si to the beginning of the array

find_smallest:
  cmp [si], bl
  jge not_smaller
  mov bl, [si]

not_smaller:
  inc si
  loop find_smallest

  ; print
  mov ah, 9
  lea dx, msg3
  int 21h
  mov dl, bl
  mov ah, 2
  int 21h   
; Find the largest value
  mov si, offset array
  mov cx, 10
  mov bh, [si] ; Initialize bh with the first element
  mov si, offset array ; Reset si to the beginning of the array

find_largest:
  cmp [si], bh
  jle not_larger
  mov bh, [si]

not_larger:
  inc si
  loop find_largest

  ; print
  mov ah, 9
  lea dx, msg4  ; Assuming msg4 is a string that says "Largest Value: $"
  int 21h
  mov dl, bh
  mov ah, 2
  int 21h


; Binary Search
  
mov si, 0            ; si is the start index of the array
mov di, len          ; di is the end index of the array
mov cx, 0            ; cx is the loop counter

binary_search_loop:
  cmp si, di
  jg not_found         ; If true, key is not found

  mov bx, si           ; bx is the start index
  add bx, di
  shr bx, 1            ; Calculating mid index (start+end)/2

  mov al, key          ; Load the key to search
  mov dl, array[bx]    ; Load the middle element

  cmp al, dl           ; Compare key with the middle element
  je found             ; If equal, key is found

  jl search_left       ; If key is less than middle element, search left
  jg search_right      ; If key is greater than middle element, search right

search_left:
  dec bx               ; Update end index to mid - 1
  mov di, bx
  jmp binary_search_loop

search_right:
  inc bx               ; Update start index to mid + 1
  mov si, bx
  jmp binary_search_loop


found:
  mov ah, 9
  lea dx, msg1
  int 21h
  jmp end_program

not_found:
  mov ah, 9
  lea dx, msg2
  int 21h
   
end_program:
  mov ah, 4Ch    
  int 21h


  
