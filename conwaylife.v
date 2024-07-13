// https://hdlbits.01xz.net/wiki/Conwaylife

module top_module(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q );

    reg [17:0] [17:0]  d ;
    reg [17:0] [17:0] nq ; // `next q`

    /* transfer 1-d array `q` to 2-d array `d`, and genrate `next q`
    i = 17      q[    0    ],  q[  15  -:16],  q[  15  ]
        16-1    q[i*16-1-15],  q[i*16-1-:16],  q[i*16-1]
        0       q[   240   ],  q[  255 -:16],  q[  255 ]
    */
    always @(q) begin
        integer i, j;

        d[0]  = {q[240], q[255-:16], q[255]};
        d[17] = {q[0],   q[15-:16],  q[15]};
        for (i = 1; i <= 16; i++)
            d[i] = {q[i*16-1-15], q[i*16-1-:16], q[i*16-1]};

        for (i = 1; i <= 16; i++)
            for (j = 1; j <= 16; j++)
                case (d[i-1][j-1] + d[i-1][j] + d[i-1][j+1]
                    + d[i][j-1]               + d[i][j+1]
                    + d[i+1][j-1] + d[i+1][j] + d[i+1][j+1])
                    'd2:     nq[i][j] = d[i][j];
                    'd3:     nq[i][j] = 'b1;
                    default: nq[i][j] = 'b0;
                endcase
    end

    // assign `next q` to `q`
    always @(posedge clk) begin
        if(load) begin
            q <= data;
        end else begin
            integer i;
            for (i = 1; i <= 16; i++)
                q[i*16-1-:16] <= nq[i][16:1];
        end
    end

endmodule
