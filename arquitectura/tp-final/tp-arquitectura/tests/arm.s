.global main
.extern printf
.extern scanf
main:
  push {ip, lr}
  ldr r0, =input
  ldr r1, =universe
  add r1, #0
  bl scanf
  ldr r0, =input
  ldr r1, =universe
  add r1, #4
  bl scanf
  ldr r0, =input
  ldr r1, =universe
  add r1, #8
  bl scanf
  ldr r0, =universe
  ldr r2, [r0, #0]
  ldr r3, =#1
  eor r1, r1
  cmp r2, r3
  moveq r1, #1
  cmp r1, #0
  bne LABEL100
  ldr r0, =universe
  ldr r2, [r0, #0]
  ldr r3, =#2
  eor r1, r1
  cmp r2, r3
  moveq r1, #1
  cmp r1, #0
  bne LABEL200
  ldr r0, =universe
  ldr r2, [r0, #0]
  ldr r3, =#3
  eor r1, r1
  cmp r2, r3
  moveq r1, #1
  cmp r1, #0
  bne LABEL300
  ldr r0, =universe
  ldr r2, [r0, #0]
  ldr r3, =#4
  eor r1, r1
  cmp r2, r3
  moveq r1, #1
  cmp r1, #0
  bne LABEL400
LABEL100:
  ldr r0, =universe
  ldr r2, [r0, #4]
  ldr r0, =universe
  ldr r3, [r0, #8]
  add r1, r2, r3
  ldr r0, =output
  bl printf
  pop {ip, pc}
  bx lr
LABEL200:
  ldr r0, =universe
  ldr r2, [r0, #4]
  ldr r0, =universe
  ldr r3, [r0, #8]
  sub r1, r2, r3
  ldr r0, =output
  bl printf
  pop {ip, pc}
  bx lr
LABEL300:
  ldr r0, =universe
  ldr r2, [r0, #4]
  ldr r0, =universe
  ldr r3, [r0, #8]
  mul r1, r2, r3
  ldr r0, =output
  bl printf
  pop {ip, pc}
  bx lr
LABEL400:
  ldr r0, =universe
  ldr r2, [r0, #4]
  ldr r0, =universe
  ldr r3, [r0, #8]
  and r1, r2, r3
  ldr r0, =output
  bl printf
  pop {ip, pc}
  bx lr
.data
input: .asciz "%d"
output: .asciz "%d\n"
universe: .fill 12
