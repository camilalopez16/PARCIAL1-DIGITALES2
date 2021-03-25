PROCESSOR 16F877A
    
    #include <xc.inc>

; CONFIGURATION WORD PG 144 datasheet

CONFIG CP=OFF ; PFM and Data EEPROM code protection disabled
CONFIG DEBUG=OFF ; Background debugger disabled
CONFIG WRT=OFF
CONFIG CPD=OFF
CONFIG WDTE=OFF ; WDT Disabled; SWDTEN is ignored
CONFIG LVP=ON ; Low voltage programming enabled, MCLR pin, MCLRE ignored
CONFIG FOSC=XT
CONFIG PWRTE=ON
CONFIG BOREN=OFF
PSECT udata_bank0

max:
DS 1 ;reserve 1 byte for max

tmp:
DS 1 ;reserve 1 byte for tmp
PSECT resetVec,class=CODE,delta=2

resetVec:
    PAGESEL INISYS ;jump to the main routine
    goto INISYS
    ; ENTRADAS
    #define S1 PORTB,0   ; SESOR NIVEL >= REFERENCIA DE AGUA  
    #define S2 PORTB,1   ; SENSOR DE TEMPERATURA >= REFERENCIA
    #define S3 PORTB,2   ; SENSOR1 DE CONCENTRACCION DE OXIGENO
    
    
    ; SALIDAS
    #define BOMBA PORTD,0
    #define LED_A PORTD,1    
    #define CALEF PORTD,2
    #define LED_R PORTD,3
    #define OXIGENO PORTD,4    
    #define LED_V PORTD,5
    
    NADA:
    BCF BOMBA
    BCF LED_A
    BCF CALEF
    BCF LED_R
    BCF OXIGENO 
    BCF LED_V
    RETURN
   
    BOMBA_LLENA:
    BSF BOMBA
    BSF LED_A
    BCF CALEF
    BCF LED_R
    BCF OXIGENO 
    BCF LED_V
    RETURN
    
    CALEFACCION:
    BCF BOMBA
    BCF LED_A
    BSF CALEF
    BSF LED_R
    BCF OXIGENO 
    BCF LED_V
    RETURN
    
    CON_OXIGENO:
    BCF BOMBA
    BCF LED_A
    BCF CALEF
    BCF LED_R
    BSF OXIGENO 
    BSF LED_V
    RETURN
    
    INISYS:
    ;Cambio a Banco 1
    BCF STATUS, 6
    BSF STATUS, 5 ; Bank1
    ; Modificar TRIS
    
    BSF TRISC,0    ; SESOR NIVEL >= REFERENCIA DE AGUA  
    BSF TRISC,1    ; SENSOR DE TEMPERATURA >= REFERENCIA
    BSF TRISC,2    ; SENSOR1 DE CONCENTRACCION DE OXIGENO 
    
    ;------------------------------------------
    
    
    BCF TRISD,0    ; BOMBA DE AGUA 
    BCF TRISD,1    ; LED AMARILLO
    BCF TRISD,2    ; TEMPERATURA
    BCF TRISD,3    ; LED ROJO 
    BCF TRISD,4    ; CONCENTRACCION DE OXIGENO 
    BCF TRISD,5    ; LED VERDE
     ; Regresar a banco 
    BCF STATUS, 5 ; Bank0

    main:
    CALL NADA
       
    NIVEL_A:
    BTFSC S1
    CALL BOMBA_LLENA
    GOTO TEMPERATURA
    
    TEMPERATURA:
    BTFSC S2
    CALL CALEFACCION
    GOTO OXIG
    
    OXIG:
    BTFSC S3
    GOTO main
    
   
   
  
     END resetVec