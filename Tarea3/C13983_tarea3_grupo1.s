##################################################################################################################################################
# Tarea 3. Estructuras de Computadoras Digitales IE0321
# Elián Jiménez Quesada - C13983																
# 20/06/2024
# I Ciclo 2024

# Explicacion de la implementacion:
					# En este programa se implementan diversos algoritmos para determinar si dos numeros enteros M Y N 
					# ingresados por un usuario se consideran PAR TORTUGA o no. 
					# M y N se consideran PAR TORTUGA si y solo si M es un numero primo y si M + N es un numero primo.
					# Para esto en primer lugar se determina la raiz de cuadrada de M y de M + N.
					# Con esto se puede determinar si un numero es primo o no, utilizando un ciclo for y un par de condicines 
					# if. Es asi como se logra determinar si M y N son PAR TORTUGA o no.
					# El programa continua preguntando por numeros al usuario hasta que cualquiera de los numeros ingresados 
					# sea 0.
					
##################################################################################################################################################


.data
	# Floats:
	two: .float 2.0						# two = 2.0 	
	zero: .float 0.0 					# zero = 0.0 
	epsilon: .float 0.001   				# epsilon = 0.001 
	
	# Caracteres:
	inputM: .asciiz "Ingrese el numero M: "
	inputN: .asciiz "Ingrese el numero N: "
	parTortuga: .asciiz "Los numeros ingresados SI son par tortuga."
	no_parTortuga: .asciiz "Los numeros ingresados NO son par tortuga."
	string: .asciiz "String:\n"
	whiteLine: .asciiz "\n"

.text	
	# Funcion que le pide al usuario que ingrese los valores de M y N
	main:
    		addi $v0, $0, 4					# $v0=4 para imprimir caracteres        		
    		la $a0, inputM       				# Carga en $a0 la direccion de la cadena "inputM"
    		syscall						# Para comunicarse con el sistema a partir del registro $v0

    		
    		addi $v0, $0, 5            			# $v0=5 para leer enteros, se lee el entero M
    		syscall						# Para comunicarse con el sistema a partir del registro $v0
    		add $a0, $0, $v0       				# Guarda en $a0 el valor de M ingresado por el usuario
    		
    		beq $a0, $0, Fin_program			# Si M = 0 finzaliza el programa, sino solicita al entero N
    		
    		addi $v0, $0, 4					# $v0=4 para imprimir caracteres
    		add $t0, $0, $a0         			# Se guarda el valor de $a0 en $t0 temporalmente
    		la $a0, inputN       				# Carga en $a0 la direccion de la cadena "inputN"
    		syscall						# Para comunicarse con el sistema a partir del registro $v0
		add $a0, $0, $t0				# Se recupera el valor de M en $a0
		
    		addi $v0, $0, 5            			# $v0=5 para leer enteros, se lee el entero N
    		syscall						# Para comunicarse con el sistema a partir del registro $v0
    		add $a1, $0, $v0       				# Guarda en $a1 el valor de N ingresado por el usuario  
			
		beq $a1, $0, Fin_program			# Si N = 0 finzaliza el programa, sino procede a determinar si son par tortuga o no
		j sqrt_bs					# Salta a sqrt_bs
	
	# Funcion que determina la raiz cuadrada de M y de M + N 	
    	sqrt_bs:
    		lwc1 $f22, two					# $f22 = 2.0
    		lwc1 $f30, zero					# $f30 = 0.0
    		lwc1 $f3, epsilon				# $f3 = 0.001 (epsilon)
    		lwc1 $f1, zero					# $f1 = 0.0 (lo)
    		
    		mtc1 $a0, $f0					# Mueve el valor de $a0 a un registro de punto flotante (x para M)
    		cvt.s.w $f0, $f0				# Convierte el valor entero a punto flotante 
    		mtc1 $a0, $f10					# Mueve el valor de $a0 a un registro de punto flotante (hi para M)
    		cvt.s.w $f10, $f10				# Convierte el valor entero a punto flotante 
    		
    		
    		add $a2, $a0, $a1				# $a2 = M + N
    		mtc1 $a2, $f2					# Mueve el valor de $a2 a un registro de punto flotante (x para M + N)
    		cvt.s.w $f2, $f2				# Convierte el valor entero a punto flotante 
    		mtc1 $a2, $f20					# Mueve el valor de $a2 a un registro de punto flotante (hi para M + N)
    		cvt.s.w $f20, $f20				# Convierte el valor entero a punto flotante 

    		# while (hi - lo > epsilon) (Para M)
    		while: 
    			sub.s $f4, $f10, $f1			# $f4 = hi - lo
    			c.lt.s $f3, $f4				# Si epsilon < (hi - lo) no sale del while
    			bc1f endWhile				# Sino, salta al endWhile
    		
    			add.s $f6, $f10, $f1			# $f6 = hi + lo
    			div.s $f6, $f6, $f22			# $f6 = (hi + lo) / 2 (guess) 
    		
    			mul.s $f16, $f6, $f6			# $f16 = guess * guess (guess_sqrd) 
    			
    			# if (guess_sqrd > x)
    			c.lt.s $f0, $f16			# si x < guess_sqrd no salta al else
    			bc1f else				# Sino, salta al else
    		
    			add.s $f10, $f30, $f6			# hi = guess	
    			j while					# Salta a while
    			
    			else:
    				add.s $f1, $f30, $f6		# lo = guess
    				j while				# Salta a while
		endWhile:
		
    		add.s $f7, $f10, $f1				# $f7 = hi + lo
    		div.s $f7, $f7, $f22				# $f7 = (hi + lo) / 2 (finalGuess) 
    		add.s $f7, $f7, $f3				# $f7 = finalGuess + epsilon (SQRT de M)
    		
    		# while (hi - lo > epsilon) (Para M + N)
    		while2: 
    			sub.s $f4, $f20, $f1			# $f4 = hi - lo
    			c.lt.s $f3, $f4				# Si epsilon < (hi - lo) no sale del while2
    			bc1f endWhile2				# Sino, salta al endWhile2
    		
    			add.s $f6, $f20, $f1			# $f6 = hi + lo
    			div.s $f6, $f6, $f22			# $f6 = (hi + lo) / 2 (guess) 
    		
    			mul.s $f16, $f6, $f6			# $f16 = guess * guess (guess_sqrd) 
    			
    			# if (guess_sqrd > x)
    			c.lt.s $f2, $f16			# si x < guess_sqrd no salta al else2
    			bc1f else2				# Sino, salta al else2
    		
    			add.s $f20, $f30, $f6			# hi = guess	
    			j while2				# Salta a while2
    			
    			else2:
    				add.s $f1, $f30, $f6		# lo = guess
    				j while2			# Salta a while2
		endWhile2:
		
    		add.s $f8, $f20, $f1				# $f8 = hi + lo
    		div.s $f8, $f8, $f22				# $f8 = (hi + lo) / 2 (finalGuess)
    		add.s $f8, $f8, $f3				# $f8 = finalGuess + epsilon (SQRT de M + N)
						
    		j is_prime					# Salta a is_prime

	# Funcion que determina si M es primo y si M + N es primo
    	is_prime:
    		addi $t0, $0, 2					# $t0 = 2
    		slt $t1, $a0, $t0 				# $t1 = 1 si M < 2
    		beq $t1, $0, M_mayor_1				# Si $t1 = 0 salta a M_mayor_1 (M es mayor que 1)				
    		add $v0, $0, $0					# $v0 = 0 (no par tortuga)
    		j is_tortoise					# Salta a is_tortoise
    		
    		M_mayor_1:
    			slt $t1, $a2, $t0 			# $t1 = 1 si M + N < 2
    			beq $t1, $0, MN_mayor_1			# Si $t1 = 0 salta a MN_mayor_1 (M + N es mayor que 1)	
    			add $v0, $0, $0				# $v0 = 0 (no par ortuga)
    			j is_tortoise				# Salta a is_tortoise
    			
    		MN_mayor_1:
   		
   		# for (int i = 2; i <= SQRT; i++) (Para M)
    		for: 
    			mtc1 $t0, $f11				# Mueve el valor de $t0 a un registro de punto flotante (i = 2)
    			cvt.s.w $f11, $f11			# Convierte el valor entero a punto flotante 
    			
    			c.le.s $f11, $f7			# Si i < SQRT(M) no sale del for
    			bc1f endFor				# Sino, salta al endFor
    			
    			div $a0, $t0				# $a0/$t0
    			mfhi $t4				# residuo de la division anterior

    			beq $t4, $0, no_prime			# Si el residuo es 0, no es primo, salta a no_prime
    			
    			j continue_for				# Salta a continue_for
    			
    			no_prime:
    				add $v0, $0, $0			# $v0 = 0 (no par tortuga)
    				j is_tortoise			# Salta a is_tortoise
    				
    			continue_for:
    				addi $t0, $t0, 1  		# $t0 = $t0 + 1
    				j for				# salta al for
    		endFor:
    		
    		addi $t0, $0, 2					# $t0 = 2 (Se reinicia $t0)
    		
    		# for (int i = 2; i <= SQRT; i++) (Para M + N)
    		for2: 
    			mtc1 $t0, $f11				# Mueve el valor de $t0 a un registro de punto flotante (i = 2)
    			cvt.s.w $f11, $f11			# Convierte el valor entero a punto flotante 
    			
    			c.le.s $f11, $f8			# Si i < SQRT(M) no sale del for2
    			bc1f endFor2				# Sino, salta al endFor2
    			
    			div $a2, $t0				# $a2/$t0
    			mfhi $t5				# residuo de la division anterior

    			beq $t5, $0, no_prime			# Si el residuo es 0, no es primo, salta a no_prime

    			addi $t0, $t0, 1  			# $t0 = $t0 + 1
    			j for2					# salta al for2
    		endFor2:
    		
    		addi $v0, $0, 1					# $v0 = 1 (par ortuga)
    		j is_tortoise					# Salta a is_tortoise
    		
    	# Funcion que determina si el par M y N corresponde a un par tortuga o no dependiendo del valor en $v0	
    	is_tortoise:
    		beq $v0, $0, no_par_Tortuga			# Si $v0 = 1 M y N son par tortuga, si $v0 = 0 M y N no son par tortuga
		
		addi $v0, $0, 4              	     		# $v0=4 para imprimir caracteres
   		la $a0, whiteLine                   		# Carga en $a0 la direccion de la cadena "\n"
    		syscall				     		# Para comunicarse con el sistema a partir del registro $v0
    		
		addi $v0, $0, 4					# $v0=4 para imprimir caracteres
		la $a0, parTortuga                      	# Carga en $a0 la direccion de la cadena "parTortuga"
		syscall						# Para comunicarse con el sistema a partir del registro $v0
		
		addi $v0, $0, 4              	     		# $v0=4 para imprimir caracteres
   		la $a0, whiteLine                   		# Carga en $a0 la direccion de la cadena "\n"
    		syscall				     		# Para comunicarse con el sistema a partir del registro $v0
    		
    		addi $v0, $0, 4              	     		# $v0=4 para imprimir caracteres
   		la $a0, whiteLine                   		# Carga en $a0 la direccion de la cadena "\n"
    		syscall				     		# Para comunicarse con el sistema a partir del registro $v0
		j main						# Salta a main
								
		no_par_Tortuga:
			addi $v0, $0, 4              	  	# $v0=4 para imprimir caracteres
   			la $a0, whiteLine                   	# Carga en $a0 la direccion de la cadena "\n"
    			syscall				     	# Para comunicarse con el sistema a partir del registro $v0
    		
			addi $v0, $0, 4				# $v0=4 para imprimir caracteres
			la $a0, no_parTortuga                  # Carga en $a0 la direccion de la cadena "no_parTortuga"
			syscall					# Para comunicarse con el sistema a partir del registro $v0
			
			addi $v0, $0, 4              	     	# $v0=4 para imprimir caracteres
   			la $a0, whiteLine                   	# Carga en $a0 la direccion de la cadena "\n"
    			syscall				     	# Para comunicarse con el sistema a partir del registro $v0
    			
    			addi $v0, $0, 4              	     	# $v0=4 para imprimir caracteres
   			la $a0, whiteLine                   	# Carga en $a0 la direccion de la cadena "\n"
    			syscall				     	# Para comunicarse con el sistema a partir del registro $v0
			j main					# Salta a main
								
	Fin_program:
		addiu $v0, $zero, 10		     		# $v0=10 para finalizar el programa
	 	syscall						# Para comunicarse con el sistema a partir del registro $v0