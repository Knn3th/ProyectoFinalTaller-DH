`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:08:03 09/27/2014 
// Design Name: 
// Module Name:    Maquina_pintar 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Maquina_pintar(Entrada,Salida,clk,reset);
	 
	 //Nuestras entradas de los sensores
	 input [5:0] Entrada;
	 input clk,reset;
	 
	 output [4:0] Salida; 
	 
	 //Nuestros registros de estados
	 reg [3:0] state = 0;
	 reg [3:0] next = 0;
	 
	 //Nuestros estados o parametros
	 parameter Inicial = 0;
	 parameter pintar = 1;
	 parameter pintarBandaEstatica = 2;
	 parameter pintarBanda1 = 3;
	 parameter pintarBanda2 = 4;
	 parameter pintarBanda3 = 5;
	 parameter pintarBanda4 = 6;
	 
	 //Si el flanco del clock se activa cambiamos de estado seg�n sea next el estado
	 //Si el reset est� en flanco entonces estado es inicial.
	 always @(posedge clk) state <= (reset)? Inicial[3:0]:next; 
	 
	 //Siempre que mi estado cambie entonces
	 // Me voy a mi estado actual por el caso y haci salto de estados
	 //Seg�n la entrada respectiva
	 always @(state or Entrada) begin
	 
		case(state)
		
			Inicial: next = (Entrada == 6'b000001)? pintar[3:0]:Inicial[3:0];
				
			pintar:
					  if(Entrada == 6'b000100) next = pintarBanda1[3:0];
				else if(Entrada == 6'b001000) next = pintarBanda2[3:0];
				else if(Entrada == 6'b010000) next = pintarBanda3[3:0];
				else if(Entrada == 6'b100000) next = pintarBanda4[3:0];
				else next = pintarBandaEstatica;
				 
			pintarBandaEstatica:
						if(Entrada == 6'b000010) next = pintarBandaEstatica[3:0];
				 else if(Entrada == 6'b000110) next = pintarBandaEstatica[3:0];
				 else if(Entrada == 6'b001010) next = pintarBandaEstatica[3:0];
				 else if(Entrada == 6'b010010) next = pintarBandaEstatica[3:0];
				 else if(Entrada == 6'b100010) next = pintarBandaEstatica[3:0];
				 else next = pintar;
			
			pintarBanda1: next = (Entrada == 6'b000100)? pintarBanda1[3:0]:pintar[3:0];
			pintarBanda2: next = (Entrada == 6'b001000)? pintarBanda2[3:0]:pintar[3:0];
			pintarBanda3: next = (Entrada == 6'b010000)? pintarBanda3[3:0]:pintar[3:0];
			pintarBanda4: next = (Entrada == 6'b100000)? pintarBanda4[3:0]:pintar[3:0];
	
		default: next = Inicial[3:0];
	
		endcase
	end
							 
	 assign Salida[0] = (state == pintarBandaEstatica[3:0]);
	 assign Salida[1] = (state == pintarBanda1[3:0]);
	 assign Salida[2] = (state == pintarBanda2[3:0]);
	 assign Salida[3] = (state == pintarBanda3[3:0]);
	 assign Salida[4] = (state == pintarBanda4[3:0]);

endmodule
