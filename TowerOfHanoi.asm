.text

main: 
	li a2, 4 # n = 4
	li a3, 1 # A = 1
	li a4,2 # B = 2
	li a5,3 # C = 3
	
	
	j towerOfHanoi
	

towerOfHanoi:
	addi sp,sp,-16 # Reservamos el espacio en el stack
	sw ra,12(sp) #Guardamos la direccion de RA
	sw a3,8(sp) #Guardamos from_rod
	sw a4,4(sp) #Guardmos to_rod
	sw a5, 0(sp) #Guardamos aux_rod
	
	
	li t0, 1 # Creamos el caso base
	beq a2,t0,label_if #Checamos si n == 1
	
	addi a2,a2,-1 #n -= 1
	
	
label_if:
	ret #return
