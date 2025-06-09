##################################################################################################################################################
# Tarea 4. Estructuras de Computadoras Digitales IE0321
# Elián Jiménez Quesada - C13983																
# 04/07/2024
# I Ciclo 2024
#
# Problema 6. Escriba, en lenguaje ensamblador de mips, una función que reciba por medio de $a0 la dirección de un array A y por $a1 N (el número 
# de palabras de este array). Este array corresponde a números enteros sin signo. La función debe devolver por $v0 el número mayor del array y 
# por $v1 el número menor del array.
#													
#
# La solucion especificamente se ve en la funcion "Problema6, lo demas es para imprimir y poder demostrar los resultados
##################################################################################################################################################

.data
	# Arreglos:
	A: .word 4, 5, 45, 8, 9, 10, 3, 13, 5, 90
	
	# Caracteres:
	array: .asciiz "Arreglo original:\n"
	mayor: .asciiz "Numero mayor:"
	menor: .asciiz "Numero menor:" 
	comma: .asciiz ","
	whiteLine: .asciiz "\n"
.text
	main:	
		
		la $a0, A                           		# Carga la direccion del array en $a0
		addi $a1, $0, 10                    		# Tamaño del array
		
		jal original_array 		     		# Salta a la funcion original_array
		j Problema6 			     		# Salta a la funcion Problema1		
	
	
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
	
	Problema6:
		la $a0, A                           		# Carga la direccion del array en $a0
		
		add $t0, $0, $0					# $t0 = i = 0
		add $v0, $0, $0					# $v0 = 0
		nor $v1, $0, $0					# $v1 = 0xFFFF FFFF
		while:	
			slt $t2, $t0, $a1			# $t2 = 1 si $t0 < $a1
			beq $t2, $0, endwhile			# Si $t2 = 0 salta a endwhile
			
			sll $t6, $t0, 2             		# $t6=i*4
			add $t6, $t6, $a0	     		# $t6=A+i*4 Direccion de A[i] 
			lw $t3, 0($t6)				# $t3 = A[i]
			
			# Verificar mayor
			slt $t2, $v0, $t3			# $t2 = 1 si $v0 < $t3
			beq $t2, $0, continuar1			# Si $t2 = 0 salta a continuar1	
			
			add $v0, $0, $t3			# Se actualiza $v0 con el mayor numero hasta el momento
			
			continuar1:
			# Verificar menor
			sltu $t4, $t3, $v1			# $t4 = 1 si $t3 < $v1
			beq $t4, $0, continuar2			# Si $t4 = 0 salta a continuar2
			
			add $v1, $0, $t3			# Se actualiza $v1 con el menor numero hasta el momento
			
			continuar2:
			
			addi $t0, $t0, 1             		# $t0 = i + 1
			j while					# Salta a while
		
		endwhile:
		
		# Imprimir la palabra "Numero mayor"
		add $t5, $0, $v0				# Guarda el valor de $v0 para no perderlo
		addi $v0, $0, 4                     		# $v0=4 para imprimir caracteres
		la $a0, mayor	       				# Carga en $a0 la dirección de la cadena "Numero mayor"
		syscall						# Para comunicarse con el sistema apartir del registro $v0
		add $v0, $0, $t5				# Restaura $v0
		
		# Imprimir el numero mayor
		add $a0, $0, $v0				# Pasa el valor de $v0 a $a0 para imprimirlo 
		addi $v0, $0, 1                     		# $v0=1 para imprimir enteros
		syscall				     		# Para comunicarse con el sistema apartir del registro $v0
		
		addi $v0, $0, 4              			# $v0=4 para imprimir caracteres
   		la $a0, whiteLine            			# Carga en $a0 la dirección de la cadena "\n"
    		syscall			      			# Para comunicarse con el sistema apartir del registro $v0
		
		# Imprimir la palabra "Numero menor"
		addi $v0, $0, 4                     		# $v0=4 para imprimir caracteres
		la $a0, menor	       				# Carga en $a0 la dirección de la cadena "Numero menor"
		syscall						# Para comunicarse con el sistema apartir del registro $v0
		
		# Imprimir el numero menor
		add $a0, $0, $v1				# Pasa el valor de $v1 a $a0 para imprimirlo 
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