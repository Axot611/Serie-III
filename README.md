# Serie-III

### En este apartado encontraras los documentos y partes de la programacion separadas.

- Project 5 es la programacion sin usar el test bench, lo que debes de hacer es descargar el doc de testbench y pegarlo en el main de la programacion para hacer la simulacion, si por alguna razon no funciona, te dejo el otro documento llamado FSM_ELEVATOR que ya tiene el test bench incluido solo para que lo pruebes.

- De igual manera encuentra el video de explicacion abajo:

<https://youtu.be/rfb76pzcqq4>


### Main module
Para la programacion tienes el main module que es donde mandas a llamar a los demas modulos, alli haces las conexiones de submodulo a submodulo.

module main_module(
    input logic clk,
    input logic rst,
    input logic S, L1, L2, L3, // Entradas para el next_state
    output logic X1, X0,        // Salidas del flip-flop
    output logic GROUND, L1_out, L2_out, L3_out, // Salidas del output_logic
    output logic VERDE_GROUND, ROJO_GROUND, // Salidas del LED_indicador para GROUND
    output logic VERDE_L1, ROJO_L1,         // Salidas del LED_indicador para L1_out
    output logic VERDE_L2, ROJO_L2,         // Salidas del LED_indicador para L2_out
    output logic VERDE_L3, ROJO_L3          // Salidas del LED_indicador para L3_out
);

    logic [1:0] next_state_out;

    // Instancia del módulo next_state con retroalimentación desde el flip-flop
    next_state ns_inst (
        .S1(X0), .S0(X1), .S(S), .L1(L1), .L2(L2), .L3(L3),
        .x(next_state_out)
    );

    // Instancia del módulo d_flipflop
    d_flipflop dff_inst (
        .clk(clk), .rst(rst),
        .D1(next_state_out[1]), .D0(next_state_out[0]),
        .X1(X1), .X0(X0)
    );

    // Instancia del módulo output_logic
    output_logic out_logic_inst (
        .S0({X1, X0}), // Conectamos X1 a S0[1] y X0 a S0[0]
        .GROUND(GROUND), 
        .L1(L1_out), 
        .L2(L2_out), 
        .L3(L3_out)
    );

    // Instancias del módulo LED_indicador para cada salida
    LED_indicador led_indicador_inst_ground (
        .S0(GROUND),    // Conectamos la salida GROUND de output_logic
        .VERDE(VERDE_GROUND),   // Salida VERDE para GROUND
        .ROJO(ROJO_GROUND)     // Salida ROJO para GROUND
    );

    LED_indicador led_indicador_inst_L1 (
        .S0(L1_out),    // Conectamos L1_out de output_logic
        .VERDE(VERDE_L1),   // Salida VERDE para L1_out
        .ROJO(ROJO_L1)     // Salida ROJO para L1_out
    );

    LED_indicador led_indicador_inst_L2 (
        .S0(L2_out),    // Conectamos L2_out de output_logic
        .VERDE(VERDE_L2),   // Salida VERDE para L2_out
        .ROJO(ROJO_L2)     // Salida ROJO para L2_out
    );

    LED_indicador led_indicador_inst_L3 (
        .S0(L3_out),    // Conectamos L3_out de output_logic
        .VERDE(VERDE_L3),   // Salida VERDE para L3_out
        .ROJO(ROJO_L3)     // Salida ROJO para L3_out
    );

    endmodule
    
### Next stage module 
EL next stage es donde ya armas tu primera parte de la logica de tu programa, aca estan todas tu entradas y salidas que van hacia los flip flops que guardaran la memoria para el siguiente estado, las entradas S0 y S1 estan siendo retroalimentadas por las salidas X1 y X0

// Módulo AND de 2 entradas
module and2(input logic a, b, output logic y);
    assign y = a & b;
endmodule

// Módulo AND de 3 entradas
module and3(input logic a, b, c, output logic y);
    assign y = a & b & c;
endmodule

// Módulo AND de 4 entradas
module and4(input logic a, b, c, d, output logic y);
    assign y = a & b & c & d;
endmodule

// Módulo AND de 5 entradas
module and5(input logic a, b, c, d, e, output logic y);
    assign y = a & b & c & d & e;
endmodule

// Módulo AND de 6 entradas
module and6(input logic a, b, c, d, e, f, output logic y);
    assign y = a & b & c & d & e & f;
endmodule

// Módulo OR de 12 entradas
module or12(input logic a, b, c, d, e, f, g, h, i, j, k, l, output logic y);
    assign y = a | b | c | d | e | f | g | h | i | j | k | l;
endmodule

// Módulo NOT
module inv(input logic a, output logic y);
    assign y = ~a;
endmodule

// Módulo principal para calcular x[1] y x[0]
module next_state(
    input logic S1, S0, S, L1, L2, L3,
    output logic [1:0] x
);
    logic nS1, nS0, nS, nL1, nL2, nL3;
    
    // Invertir señales
    inv not_S1(S1, nS1);
    inv not_S0(S0, nS0);
    inv not_S(S, nS);
    inv not_L1(L1, nL1);
    inv not_L2(L2, nL2);
    inv not_L3(L3, nL3);
    
    // Términos de x[1]
    logic t1, t2, t3, t4, t5, t6, t7;
    and5 and1(S1, nS, nL1, nL2, L3, t1);
    and5 and2(S1, nS, nL1, L2, nL3, t2);
    and3 and3(S0, nS, nL1, t3);
    and2 and4(S0, L3, t4);
    and2 and5(S0, L2, t5);
    and3 and6(S0, S, L1, t6);
    and2 and7(S0, S1, t7);
    
    or12 or_x1(t1, t2, t3, t4, t5, t6, t7, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, x[1]);
    
    // Términos de x[0]
    logic u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12;
    and5 and8(nS1, nS, nL1, nL2, L3, u1);
    and6 and9(nS0, nS1, nS, nL1, L2, nL3, u2);
    and3 and10(S1, L2, L3, u3);
    and3 and11(S1, S, L3, u4);
    and3 and12(S1, S, L2, u5);
    and5 and13(nS1, nS, L1, nL2, nL3, u6);
    and6 and14(S0, nS1, S, nL1, nL2, nL3, u7);
    and3 and15(S1, L1, L2, u8);
    and3 and16(S1, S, L1, u9);
    and5 and17(S1, nS, nL1, nL2, nL3, u10);
    and3 and18(nS0, S1, L1, u11);
    and3 and19(S0, S1, L3, u12);
    
    or12 or_x0(u1, u2, u3, u4, u5, u6, u7, u8, u9, u10, u11, u12, x[0]);
    
endmodule

### Flip Flop module 
En este modulo tenemos la creacion de dos flip flops que son los encargados de guardar la memoria para nuestro programa.

module d_flipflop (
    input logic clk,
    input logic rst,
    input logic D1,
    input logic D0,
    output logic X1,
    output logic X0
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            X1 <= 1'b0;
            X0 <= 1'b0;
        end else begin
            X1 <= D1;
            X0 <= D0;
        end
    end
endmodule

### Output logic module
En este modulo ya traducimos los valores que tenemos de las salidas de nuestra maquina moore y los vamos a interpretar para ver el comportamiento de nuestro sistema:

// Módulo AND de dos entradas (renombrado)
module and2_alt(input logic a, b,
                output logic y);
    assign y = a & b;
endmodule

// Módulo Inversor (NOT) renombrado
module inv_alt(input logic a,
               output logic y);
    assign y = ~a;
endmodule

// Módulo OUTPUTLOGIC con lógica modificada y módulos renombrados
module output_logic (
    input logic [1:0] S0,      // Entradas de estado S0 (2 bits)
    output logic GROUND,        // Salida GROUND
    output logic L1,            // Salida L1
    output logic L2,            // Salida L2
    output logic L3             // Salida L3
);
    logic inv_S0_1, inv_S0_0;  // Variables para las señales invertidas de S0[1] y S0[0]

    // Inversores para S0[1] y S0[0] con nombres renombrados
    inv_alt inv1(S0[1], inv_S0_1);  // Inversión de S0[1]
    inv_alt inv2(S0[0], inv_S0_0);  // Inversión de S0[0]

    // AND para GROUND = ~S0[1] ⋅ ~S0[0]
    and2_alt and_gate1(inv_S0_1, inv_S0_0, GROUND);  // AND de las señales invertidas de S0[1] y S0[0]
    
    // AND para L1 = ~S0[1] ⋅ S0[0]
    and2_alt and_gate2(inv_S0_1, S0[0], L1);  // AND de S0[1] invertido y S0[0]
    
    // AND para L2 = S0[1] ⋅ ~S0[0]
    and2_alt and_gate3(S0[1], inv_S0_0, L2);  // AND de S0[1] y S0[0] invertido
    
    // AND para L3 = S0[1] ⋅ S0[0]
    and2_alt and_gate4(S0[1], S0[0], L3);  // AND de las señales originales S0[1] y S0[0]
    
endmodule

### Led indicador module
En este modulo ya esta todo traducido para ver las los resultados de todo lo que esta sucediendo en nuestra maquina de estados.

module LED_indicador (
    input logic S0,         // Entrada de estado S0 (1 bit)
    output logic VERDE,     // Salida VERDE
    output logic ROJO       // Salida ROJO
);

    // Asignaciones directas y NOT
    assign VERDE = S0;          // VERDE = S0
    assign ROJO = ~S0;          // ROJO = ~S0 (inverso de S0)

endmodule
