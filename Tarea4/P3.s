##################################################################################################################################################
# Tarea 4. Estructuras de Computadoras Digitales IE0321
# Elián Jiménez Quesada - C13983																
# 04/07/2024
# I Ciclo 2024
#
# Problema 3. Escriba en lenguaje ensamblador de Mips el siguiente código que está en alto nivel:
#													i=0; 
#													while(A[i]>=0) 
#													{ 
#														for(j=0;j<i;j++) 
#														{ 
#															3A[i]=A[i]+A[j]; 
#														} 
#														i++; 
#													} 
#
# La solucion especificamente se ve en la funcion "Problema3, lo demas es para imprimir y poder demostrar los resultados
##################################################################################################################################################

.data
	# Arreglos:
	A: .word 1, 5, 0, 8, 9, 10, 3, 13, 11, -1
	
	# Caracteres:
	array: .asciiz "Arreglo original:\n"
	arrayN: .asciiz "Arreglo nuevo:\n"  
	comma: .asciiz ","
	whiteLine: .asciiz "\n"
.text
	main:	
		
		la $s0, A                           		# Carga la direccion del array en $s0
		addi $t2, $0, 10                    		# Tamaño del array
		
		jal original_array 		     		# Salta a la funcion original_array
		jal Problema3 			     		# Salta a la funcion Problema1		
	
	
	# Funcion para imprimir el array original 
	original_array:
	
		# Se guarda $ra del main ya que se utiliza otro jal para imprimir el arreglo
		addi $sp, $sp, -4 		     		# Se pide espacio en la pila
              	sw $ra, 0($sp)    		     		# Se guarda en la pila $ra de la funcion main
              	
              	# Imprimir la palabra "Arreglo original"
		addi $v0, $0, 4                     		# $v0=4 para imprimir caracteres
		la $a0, array                       		# Carga en $a0 la dirección de la cadena "Arreglo original"
		syscall				     		# Para comunicarse con el sistema apartir del registro $v0
		jal print_array			     		# Salta a la funcion print_array
		
		lw $ra, 0($sp)   		     		# cargamos en $ra direccion al main
		addi $sp, $sp, 8 		     		# Se restaura la pila
		jr $ra			             		# Retorna al punto de llamada
	
	Problema3:
		# Imprimir la palabra "Arreglo nuevo"
		addi $v0, $0, 4                     		# $v0=4 para imprimir caracteres
		la $a0, arrayN	       				# Carga en $a0 la dirección de la cadena "Arreglo nuevo"
		syscall				     		# Para comunicarse con el sistema apartir del registro $v0
		
		add $t0, $0, $0					# $t0 = i = 0
		while:	
		
			sll $t7, $t0, 2             		# $t7 = i*4
			add $t7, $t7, $s0	     		# $t7 = A + i*4 Direccion de A[i]
			lw $t5, 0($t7)				# $t5 = A[i]
			
			slt $t1, $t5, $0			# $t1 = 1 si A[i] < 0
			bne $t1, $0, endwhile			# Si $t1 = 0 salta a endwhile
			
			add $t3, $0, $0				# $t3 = j = 0
			for:
				slt $t1 $t3, $t0		# $t1 = 1 si j < i
				beq $t1, $0, endFor
				
				sll $t7, $t0, 2             		# $t7 = i*4
				add $t7, $t7, $s0	     		# $t7 = A + i*4 Direccion de A[i]
				lw $t5, 0($t7)				# $t5 = A[i]
			
				sll $t6, $t3, 2             	# $t6 = j*4
				add $t6, $t6, $s0	     	# $t6 = A + j*4 Direccion de A[j]
				lw $t4, 0($t6)			# $t4 = A[j]
				
				add $t5, $t5, $t4		# $t5 = A[i] + A[j]
				sw $t5, 0($t7)			# Se actualiza el valor del arreglo en A[i]
				
				addi $t3, $t3, 1             	# $t3 = i + 1
				j for
			
			endFor:
			
			addi $t0, $t0, 1             		# $t0 = i + 1
			j while
		
		endwhile:
		
		add $t0, $0, $0              	     		# $t0=i=0 reinicio de $t0 porque ya recorrio todo el array
		jal print_array			     		# Salta a la funcion print_array
		
		jal Fin_program			     		# Salta a la funcion Fin_program
	
	# Funcion para finalizar el programa
	Fin_program:
		addiu $v0, $zero, 10		     		# $v0=10 para finalizar el programa
	 	syscall				     		# Para comunicarse con el sistema a partir del registro $v0
		
		
	# Funcion para imprimir los arreglos.
	print_array:
	
		# Este while recorre el array hasta TamañoArray-1 e imprime los valores seguidos de una coma ",".
		# Cuando sale del while imprime el ultimo valor del array pero sin coma ","
		While:
			sll $t1, $t0, 2             		# $t1=i*4
			add $t1, $t1, $s0	     		# $t1=A+i*4 Direccion de A[i]
			addi $t5, $t2, -1	     		# se resta -1 al tamaño del array para que el ultimo valor no lleve coma ","
			
			slt $t3, $t0, $t5    	     		# $t3=1 si i<9
			beq $t3, $0 endWhile	     		# Si $t3=0 termina el ciclo while
			lw $a0, 0($t1)	             		# Carga en $a0 el numero alamacenado en A[i]
			
			addi $v0, $0, 1              		# $v0=4 para imprimir enteros
			syscall                      		# Para comunicarse con el sistema apartir del registro $v0
			addi $v0, $0, 4              		# $v0=4 para imprimir caracteres
   			la $a0, comma                		# Carga en $a0 la dirección de la cadena ","
    			syscall			      		# Para comunicarse con el sistema apartir del registro $v0
    			
			addi $t0, $t0, 1	      		# $t0=$t0 + 1 
			j While			      		# repite el ciclo while
		endWhile:
			sll $t1, $t0, 2        	      		# t1=i*4
			add $t1, $t1, $s0	      		# $t1=A+i*4 Direccion de A[i]
			lw $a0, 0($t1)		      		# Carga en $a0 el numero alamacenado en A[i]
			addi $v0, $0, 1              		# $v0=4 para imprimir enteros
			syscall			      		# Para comunicarse con el sistema apartir del registro $v0
			addi $v0, $0, 4              		# $v0=4 para imprimir caracteres
   			la $a0, whiteLine            		# Carga en $a0 la dirección de la cadena "\n"
    			syscall			      		# Para comunicarse con el sistema apartir del registro $v0
			add $t0, $0, $0              		# $t0=i=0 reinicio de $t0 porque ya recorrio todo el array
			jr $ra			     		# Retorna al punto de llamada
