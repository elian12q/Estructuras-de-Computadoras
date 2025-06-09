##################################################################################################################################################
# Tarea 2. Estructuras de Computadoras Digitales IE0321
# Elián Jiménez Quesada - C13983																
# 26/05/2024
# I Ciclo 2024

# ***** Elegir el arreglo de caracteres que se quiere probar en las lineas 75, 90 y 116 *****


# Explicacion de la implementacion:
					# En este programa se implementa una solucion para determinar si los parentesis en un string de caracteres #
					# son validos, es decir que todo parentesis que se abre se cierra con el mismo tipo de parentesis, los     # 
					# parentesis que se abren se cierran en el orden correcto y que todo parentesis que cierra tiene un        #
					# correspondiente parentesis que abre.									      #
					# Para esto, en primer lugar se determina si la cantidad de parentesis es par o impar, si es impar se      #
					# se consideran como invalidos, si es par pasa a un segundo analisis.					      #
					# En el segundo analisis se recorre la cadena de caracteres y se ingresan los parentesis que abren "(",    #
					# "[" y "{" a la pila. Luego con los parentesis que cierran ")", "]" y "}" se evalua el ultimo parentesis  #
					# de abrir agregado a la pila para ver si corresponde con el parentesis de cerrar que se esta analizando.  #
					# Por ejemplo, si analiza "]" entonces el ultimo caracter agregado a la pila deberia ser "[", de ser asi,  #
					# se elimina "[" de la pila y se sigue reorriendo la cadena, pero si no es "[", ya se consideraria un caso #
					# de parentesis invalidos.							      			      #
					# Ademas, si el primer parentesis de la cadena es de cerrar ")", "]" y "}" se considera un caso de         #
					# parentesis invalidos.											      #
			
					
##################################################################################################################################################


.data

# Caracteres:
array1: .asciiz " "
array2: .asciiz "()"
array3: .asciiz "(){}{{{()}}()}"
array4: .asciiz "(hay [varios {niveles} de] parentesis)"
array5: .asciiz "(se cierra con un tipo {diferente}]"
array6: .asciiz "{este deja (un nivel abierto)!"
array7: .asciiz "este, por otro lado, cierra 2 veces sin abrir])"
array8: .asciiz "[{y este ultimo cierra en un orden incorrecto]}"

valid: .asciiz "Parentesis validos.\n"
invalid: .asciiz "Parentesis invalidos.\n"
string: .asciiz "String:\n"
whiteLine: .asciiz "\n"

.text
	main:
		add $t3, $0, $0                     		# inicio de contador $t3 = 0. Contador de parentesis
		add $t6, $0, $0                     		# inicio de contador2 $t6 = 0. Este se usa para analizar el primer parentesis de la cadena
		add $t7, $0, $0                     		# inicio de contador3 $t7 = 0. Contador de elementos ingresados a la pila
		jal parentesis_validos				# Salta a la funcion parentesis validos
		jal print_array					# Salta a la funcion print_array
		jal contador					# Salta a la funcion contador
		jal validacion1					# Salta a la funcion validacion1
		jal validacion2					# Salta a la funcion validacion2
		jal validos				     	# Salta a la funcion validos
	
	# Funcion para guardar los valores en ASCII de los parentesis
	parentesis_validos:
		addi $s0, $0, 40		     		# 40  = "("	
		addi $s1, $0, 41		     		# 41  = ")"
		addi $s2, $0, 91		     		# 91  = "["	
		addi $s3, $0, 93		     		# 93  = "]"
		addi $s4, $0, 123		     		# 123 = "{"	
		addi $s5, $0, 125		     		# 125 = "}"
		
		jr $ra						# Retorna al punto de llamada
		
	# Funcion para imprimir el arreglo de caracteres
	print_array:
		addi $v0, $0, 4					# $v0=4 para imprimir caracteres
		la $a0, string                      		# Carga en $a0 la direccion de la cadena "String"
		syscall				     		# Para comunicarse con el sistema a partir del registro $v0
		
		addi $v0, $0, 4                     		# $v0=4 para imprimir caracteres
		la $a0, array3                      		# Carga en $a0 la direccion de la cadena de caracteres
		syscall				     		# Para comunicarse con el sistema a partir del registro $v0
		
		addi $v0, $0, 4              	     		# $v0=4 para imprimir caracteres
   		la $a0, whiteLine                   		# Carga en $a0 la direccion de la cadena "\n"
    		syscall				     		# Para comunicarse con el sistema a partir del registro $v0
    		
    		addi $v0, $0, 4              	     		# $v0=4 para imprimir caracteres
   		la $a0, whiteLine                   		# Carga en $a0 la direccion de la cadena "\n"
    		syscall				     		# Para comunicarse con el sistema a partir del registro $v0
		
		jr $ra						# Retorna al punto de llamada
	
	# Esta funcion recorre el arreglo de caracteres y cuenta los parentesis que hay en total
	contador:
		la $a0, array3                      		# Carga en $a0 la direccion de cualquier arreglo de caracteres entre array1 hasta array8
		
		while1: 
			lb $t1, 0($a0)  	     		# Carga el byte de la direccion de $a0 en $t1 (caracter actual)
    			beq $t1, $zero, endWhile1    		# Si el caracter es '\0', sale  del while
    		
    			beq $t1, $s0, parentesis    		# Analiza si el caractere es alguno de los parentesis
    			beq $t1, $s1, parentesis
    			beq $t1, $s2, parentesis
    			beq $t1, $s3, parentesis
    			beq $t1, $s4, parentesis
    			bne $t1, $s5, no_parentesis 		# Si es cualquier otro caracter, sigue con el siguiente
    		
    		
    			parentesis:
    			addi $t3, $t3, 1		     	# Si el caracter es algun parentesis $t3 = $t3 + 1
    		
    			no_parentesis:
    			addi $a0, $a0, 1  		     	# Incrementa el puntero de la cadena
    			j while1  			     	# Repite el ciclo while 
    		
    		endWhile1:
    			jr $ra					# Retorna al punto de llamada
    	
    	# Funcion que determina si los parentesis son validos o invalidos 	
    	validacion2:
    		la $a0, array3                      		# Carga en $a0 la direccion de cualquier arreglo de caracteres entre array1 hasta array8
		add $t7, $t3, $t0				# Se guarda la cantidad de parentesis en $t7
		
		while2: 
			lb $t1, 0($a0)  	     		# Carga el byte de la direccion de $a0 en $t1 (caracter actual)
    			beq $t1, $zero, endWhile2    		# Si el caracter es '\0', sale  del while
    			
    			beq $t7, $t3, primer_parentesis 	# Se determina si es el primer parentesis del arreglo
    			
    			# Para parentesis que no son el primero 
    			beq $t1, $s0, push    			# Si el parentesis analizado es de abrir, salta a push
    			beq $t1, $s1, parentesis_cierre1	# Si el parentesis analizado es ")", salta a parentesis_cierre1
    			beq $t1, $s2, push			# Si el parentesis analizado es de abrir, salta a push
    			beq $t1, $s3, parentesis_cierre2	# Si el parentesis analizado es "]", salta a parentesis_cierre2
    			beq $t1, $s4, push			# Si el parentesis analizado es de abrir, salta a push
    			beq $t1, $s5, parentesis_cierre3 	# Si el parentesis analizado es "}", salta a parentesis_cierre3
    			j next
    			
    			primer_parentesis:			
    				beq $t1, $s0, push	    	# Si el primer parentesis es de abrir, lo agrega a la pila
    				beq $t1, $s1, invalidos		# Si el primer parentesis es de cerrar, los parentesis son invalidos
    				beq $t1, $s2, push		# Si el primer parentesis es de abrir, lo agrega a la pila
    				beq $t1, $s3, invalidos		# Si el primer parentesis es de cerrar, los parentesis son invalidos
    				beq $t1, $s4, push		# Si el primer parentesis es de abrir, lo agrega a la pila
    				beq $t1, $s5, invalidos	 	# Si el primer parentesis es de cerrar, los parentesis son invalidos
    				j next
    			
    			# Para agregar parentesis a la pila	
    			push:
    				addi $sp, $sp, -1   		# Se pide espacio en la pila
    				sb $t1, 0($sp)      		# Se guarda en la pila el parentesis analizado
    				addi $t6, $t6, 1		# Se suma 1 al contador de elementos en la pila
    				j next				# Salta a next para analizar el siguiente caracter
    			
    			# Para ")"
    			parentesis_cierre1:
    				lb $t2, 0($sp)			# Se carga el ultimo caracter agregado a la pila
    				bne $t2, $s0, invalidos		# Si el parentesis cargado no es "(", los parentesis son invalidos
    				addi $t6, $t6, -1 		# Se resta 1 al contador de elementos en la pila
    				j remove			# Si el parentesis cargado si es "(", lo saca de la pila
    			
    			# Para "]"
    			parentesis_cierre2:
    				lb $t2, 0($sp)			# Se carga el ultimo caracter agregado a la pila
    				bne $t2, $s2, invalidos		# Si el parentesis cargado no es "[", los parentesis son invalidos
    				addi $t6, $t6, -1 		# Se resta 1 al contador de elementos en la pila
    				j remove			# Si el parentesis cargado si es "[", lo saca de la pila
    			
    			# Para "}"
    			parentesis_cierre3:
    				lb $t2, 0($sp)			# Se carga el ultimo caracter agregado a la pila
    				bne $t2, $s4, invalidos		# Si el parentesis cargado no es "{", los parentesis son invalidos
    				addi $t6, $t6, -1 		# Se resta 1 al contador de elementos en la pila
    				j remove			# Si el parentesis cargado si es "{", lo saca de la pila
    				
    			remove:
    				addi $sp, $sp, 1      		# Se restaura un byte de la pila para eliminar el ultimo caracter agregado
    				j next				# Salta a next para analizar el siguiente caracter
    			
    			next: 
    				addi $a0, $a0, 1		# Incrementa el puntero de la cadena
    				addi $t7, $t7, -1		# Le resta 1 a $t7 para saber que ya se analizo el primer parentesis
    				j while2  			# Repite el ciclo while
    		endWhile2:
    			beq $t6, $0, retorno			# Si la pila se vacio, retorna al main, sino, significa que se abrieron parentesis
    								# pero no se cerraron
    								
    			add $sp, $sp, $t6      			# Se restaura la pila para eliminar los parentesis agregados que no se
    								# se cerraron
    								
    			j invalidos				# Si hay parentsis sin cerrar, los parentesis son invalidos
    			
    			retorno:
    				jr $ra				# Retorna al punto de llamada
    		
    	# Funcion que determina si la cantidad de parentesis es par o impar
	validacion1:
		andi $t2, $t3, 1				# Si $t2 = 0, la cantidad de parentesis es par
		beq $t2, $0, par				# Y continua con la siguiente validacion
		
		j invalidos 					# Si la cantidad de parentesis es impar, los parentesis son invalidos
		
		par:
			jr $ra					# Retorna al punto de llamada
			
	# Funcion que asigna un 1 a $v0 cuando los parentesis son validos
	validos:
    		addi $v0, $0, 1
    		j Fin_program					# Salta a Fin_program
    	
    	# Funcion que asigna un 0 a $v0 cuando los parentesis son invalidos
    	invalidos:
    		add $v0, $0, $0
    		j Fin_program					# Salta a Fin_program
    		
	# Funcion para finalizar el programa
	Fin_program:
		beq $v0, $0, print_invalidos			# Si $v0 = 1 los parentesis son validos, si $v0 = 0 los parentesis son invalidos
		
		addi $v0, $0, 4					# $v0=4 para imprimir caracteres
		la $a0, valid                      		# Carga en $a0 la direccion de la cadena "valid"
		syscall						# Para comunicarse con el sistema a partir del registro $v0
		j end						# Salta a end
								
		print_invalidos:
			addi $v0, $0, 4				# $v0=4 para imprimir caracteres
			la $a0, invalid                      	# Carga en $a0 la direccion de la cadena "invalid"
			syscall					# Para comunicarse con el sistema a partir del registro $v0
		
		end:
			addiu $v0, $zero, 10		     	# $v0=10 para finalizar el programa
	 		syscall					# Para comunicarse con el sistema a partir del registro $v0
		
		
		
		
		
