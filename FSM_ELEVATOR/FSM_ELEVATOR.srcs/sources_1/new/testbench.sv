`timescale 1ns/1ps

module main_module_tb;

    logic clk, rst, S, L1, L2, L3;
    logic X1, X0;
    logic GROUND, L1_out, L2_out, L3_out;
    logic VERDE_GROUND, ROJO_GROUND;
    logic VERDE_L1, ROJO_L1;
    logic VERDE_L2, ROJO_L2;
    logic VERDE_L3, ROJO_L3;

    // Instancia del módulo principal
    main_module uut (
        .clk(clk), .rst(rst), .S(S), .L1(L1), .L2(L2), .L3(L3),
        .X1(X1), .X0(X0), .GROUND(GROUND), .L1_out(L1_out), .L2_out(L2_out), .L3_out(L3_out),
        .VERDE_GROUND(VERDE_GROUND), .ROJO_GROUND(ROJO_GROUND),
        .VERDE_L1(VERDE_L1), .ROJO_L1(ROJO_L1), .VERDE_L2(VERDE_L2), .ROJO_L2(ROJO_L2),
        .VERDE_L3(VERDE_L3), .ROJO_L3(ROJO_L3)
    );

    // Generador de reloj (1 Hz → periodo de 1s)
    always #500 clk = ~clk;  

    initial begin
        // Inicialización
        clk = 0;
        rst = 1;
        S = 0; L1 = 0; L2 = 0; L3 = 0;
        #1000 rst = 0;  // Quitamos reset después de 1 ciclo de reloj

        // Simulación de pulsaciones de botones
        #1000 S = 1;   // Presiono S
        #1000 S = 0;  

        #1000 L1 = 1;  // Presiono L1
        #1000 L1 = 0;

        #1000 L2 = 1;  // Presiono L2
        #1000 L2 = 0;

        #1000 L3 = 1;  // Presiono L3
        #1000 L3 = 0;

        #2000 $finish;  // Terminar simulación
    end

endmodule
