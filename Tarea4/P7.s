##################################################################################################################################################
# Tarea 4. Estructuras de Computadoras Digitales IE0321
# Elián Jiménez Quesada - C13983																
# 04/07/2024
# I Ciclo 2024
#
# Problema 7. Escriba, en lenguaje ensamblador de mips, una función que reciba por medio de $a0 la dirección de un array A y por $a1 N (el número
# de palabras de este array). Este array corresponde a números enteros sin signo. La función debe devolver por $v0 un uno si hay dos números
# iguales consecutivos en el array y un cero en caso contrario.
#													
# Se puede editar el arrelgo A para ver un caso de $v0 = 0
# La solucion especificamente se ve en la funcion "Problema7, lo demas es para imprimir y poder demostrar los resultados
##################################################################################################################################################

.data
	# Arreglos:
	A: .word 4, 5, 4, 8, 7, 35, 3, 9, 99, 99
	
	# Caracteres:
	array: .asciiz "Arreglo original:\n"
	r: .asciiz "Resultado: $v0 = "

	comma: .asciiz ","
	whiteLine: .asciiz "\n"
.text
	main:	
		
		la $a0, A                           		# Carga la direccion del array en $a0
		addi $a1, $0, 10                    		# Tamaño del array
		
		jal original_array 		     		# Salta a la funcion original_array
		j Problema7 			     		# Salta a la funcion Problema1		
	
	
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
	
	Problema7:
		la $a0, A                           		# Carga la direccion del array en $a0
		
		addi $t1, $a1, -1	     			# Se resta -1 al tamaño del array para que el ultimo se analice ya que no hay mas
								# valores por delante
		
		add $t0, $0, $0					# $t0 = i = 0
		while:	
			slt $t2, $t0, $t1			# $t2 = 1 si $t0 < $t1
			beq $t2, $0, endwhile			# Si $t2 = 0 salta a endwhile
			
			sll $t6, $t0, 2             		# $t6=i*4
			add $t6, $t6, $a0	     		# $t6=A+i*4 Direccion de A[i] 
			lw $t3, 0($t6)				# $t3 = A[i]
			lw $t4, 4($t6)				# $t3 = A[i+1]
			
			beq $t3, $t4, SiHay			# Si A[i] = A[i+1] salta a SiHay, sino sigue analizando
			
			addi $t0, $t0, 1             		# $t0 = i + 1
			j while					# Salta a while
		
		endwhile:
		add $v0, $0, $0					# $a0 = 0
		j fin						# salta a fin
		
		SiHay:
		addi $v0, $0, 1					# $a0 = 1	
		
		fin:
		# Imprimir la cadena "Resultado: $v0 = "
		add $t5, $0, $v0				# Guarda el valor de $v0 para no perderlo
		addi $v0, $0, 4                     		# $v0=4 para imprimir caracteres
		la $a0, r	       				# Carga en $a0 la dirección de la cadena "Resultado: $v0 = "
		syscall						# Para comunicarse con el sistema apartir del registro $v0
		add $v0, $0, $t5				# Restaura $v0
		
		# Imprimir el valor de $v0
		add $a0, $0, $v0				# Pasa el valor de $v0 a $a0 para imprimirlo 
		addi $v0, $0, 1                     		# $v0=1 para imprimir enteros
		syscall						# Para comunicarse con el sistema apartir del registro $v0
		
		j Fin_program			     		# Salta a la funcion Fin_program
	
	# Funcion para finalizar el programa
	Fin_program:
		addiu $v0, $zero, 10		     		# $v0=10 para finalizar el programa
	 	syscall				     		# Para comunicarse con el sistema a partir del registro $v0
		
		
	# Funcion para imprimir los arreglos.
	print_array:
		la $a0, A                           		# Carga la direccion del array en $a0
		# Este while recorre el array hasta TamañoArray-1 e imprime los valores seguidos de una coma ",".
		# Cuando sale del while imprime el ultimo valor del array pero sin coma ","
		While:
			sll $t1, $t0, 2             		# $t1=i*4
			add $t1, $t1, $a0	     		# $t1=A+i*4 Direccion de A[i]
			addi $t5, $a1, -1	     		# se resta -1 al tamaño del array para que el ultimo valor no lleve coma ","
			
			slt $t3, $t0, $t5    	     		# $t3=1 si i<9
			beq $t3, $0 endWhile	     		# Si $t3=0 termina el ciclo while
			lw $a0, 0($t1)	             		# Carga en $a0 el numero alamacenado en A[i]
			
			
			addi $v0, $0, 1              		# $v0=4 para imprimir enteros
			syscall                      		# Para comunicarse con el sistema apartir del registro $v0
			la $a0, A                           	# Carga la direccion del array en $a0
			
			addi $v0, $0, 4              		# $v0=4 para imprimir caracteres
   			la $a0, comma                		# Carga en $a0 la dirección de la cadena ","
    			syscall			      		# Para comunicarse con el sistema apartir del registro $v0
    			la $a0, A                           	# Carga la direccion del array en $a0
    			
			addi $t0, $t0, 1	      		# $t0=$t0 + 1 
			j While			      		# repite el ciclo while
		endWhile:
			sll $t1, $t0, 2        	      		# t1=i*4
			add $t1, $t1, $a0	      		# $t1=A+i*4 Direccion de A[i]
			lw $a0, 0($t1)		      		# Carga en $a0 el numero alamacenado en A[i]
			addi $v0, $0, 1              		# $v0=4 para imprimir enteros
			syscall			      		# Para comunicarse con el sistema apartir del registro $v0
			la $a0, A                           	# Carga la direccion del array en $a0
			
			addi $v0, $0, 4              		# $v0=4 para imprimir caracteres
   			la $a0, whiteLine            		# Carga en $a0 la dirección de la cadena "\n"
    			syscall			      		# Para comunicarse con el sistema apartir del registro $v0
    			la $a0, A                           	# Carga la direccion del array en $a0
    			
			add $t0, $0, $0              		# $t0=i=0 reinicio de $t0 porque ya recorrio todo el array
			jr $ra