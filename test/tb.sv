
module tb;
parameter SIZE =28, SIZEKer = 5, WIDTH_BIT = 128;
parameter STEP_MAX_POOLING = 2;
parameter SIZEINPUT_POOLING = SIZE - SIZEKer + 1;
    integer mmm;
    // integer sum;
logic signed [WIDTH_BIT-1:0]sum;

parameter SIZEPOOLING = 2,SIZEOUTCONV = (SIZEINPUT_POOLING - 2)/STEP_MAX_POOLING + 1;
parameter FILTER_N1D = 2;
parameter FILTER_N2D = 8;

logic clock, nreset1,nreset2, nreset3, nreset4,ena;
logic done0;
logic done1;

real timestart, timestop;

logic signed  [WIDTH_BIT-1:0] inpMatrixI          [SIZE-1:0][SIZE-1:0]                                      ;
logic signed  [WIDTH_BIT-1:0] inpMatrixIdinKer    [SIZEKer-1:0][SIZEKer-1:0]                                ;
logic signed  [WIDTH_BIT-1:0] convIxKernel                                                                  ;
logic signed  [WIDTH_BIT-1:0]bias0;
logic signed  [WIDTH_BIT-1:0]bias1;
logic signed  [WIDTH_BIT-1:0]bias [FILTER_N1D-1:0];


logic signed  [WIDTH_BIT-1:0] i, j, next,current;
logic signed [WIDTH_BIT-1:0] Kernel00 [SIZEKer-1:0][SIZEKer-1:0];
logic signed [WIDTH_BIT-1:0] Kernel01 [SIZEKer-1:0][SIZEKer-1:0];
logic signed  [WIDTH_BIT-1:0] convIxKernelOut0     [SIZE-SIZEKer:0][SIZE-SIZEKer:0]     ;
logic signed  [WIDTH_BIT-1:0] convIxKernelOut1     [SIZE-SIZEKer:0][SIZE-SIZEKer:0]     ;
logic signed  [WIDTH_BIT-1:0] maxPoolingOut0       [SIZEOUTCONV-1:0][SIZEOUTCONV-1:0]   ;
logic signed  [WIDTH_BIT-1:0] maxPoolingOut1       [SIZEOUTCONV-1:0][SIZEOUTCONV-1:0]   ;
logic signed  [WIDTH_BIT-1:0] maxPoolingIxKernel0  [SIZEOUTCONV-1:0][SIZEOUTCONV-1:0    ];
logic signed  [WIDTH_BIT-1:0] maxPoolingIxKernel1  [SIZEOUTCONV-1:0][SIZEOUTCONV-1:0    ];
conv1D #(.SIZE(SIZE),.SIZEKer(SIZEKer),.WIDTH_BIT(WIDTH_BIT)) conv0 (
            .clock                  (clock                              )                               ,
            .nreset                 (nreset1                            )                               ,
            .inpMatrixI             (inpMatrixI                         )                               ,
            .Kernel                 (Kernel00                            )                               ,
            .done                   (done0                              )                               ,
            .bias                   (bias0                              )                                ,
            .convIxKernelOut    (convIxKernelOut0                   )
);
conv1D #(.SIZE(SIZE),.SIZEKer(SIZEKer),.WIDTH_BIT(WIDTH_BIT)) conv2 (
            .clock                  (clock                              )                               ,
            .nreset                 (nreset1                            )                               ,
            .inpMatrixI             (inpMatrixI                         )                               ,
            .Kernel                 (Kernel01                            )                               ,
            .done                   (done1                              )                               ,
            .bias                   (bias1                              )                                ,
            .convIxKernelOut    (convIxKernelOut1                   )
);

maxpooling #(.SIZE(SIZE-SIZEKer),.STEP_MAX_POOLING(STEP_MAX_POOLING),.SIZEOUTCONV(SIZEOUTCONV),.SIZEPOOLING(SIZEPOOLING),.WIDTH_BIT(WIDTH_BIT)) maxPooling0 (
            .clock                              (clock                  )                               ,
            .nreset                             (nreset2                )                               ,
            .convIxKernelOut                    (convIxKernelOut0       )                               ,
            .done                               (done0m                 )                               ,
            .maxPoolingOut                      (maxPoolingOut0         )
);

maxpooling #(.SIZE(SIZE-SIZEKer),.STEP_MAX_POOLING(STEP_MAX_POOLING),.SIZEOUTCONV(SIZEOUTCONV),.SIZEPOOLING(SIZEPOOLING),.WIDTH_BIT(WIDTH_BIT)) maxPooling1 (
            .clock                              (clock                  )                               ,
            .nreset                             (nreset2                )                               ,
            .convIxKernelOut                    (convIxKernelOut1       )                               ,
            .done                               (done0m                 )                               ,
            .maxPoolingOut                      (maxPoolingOut1         )
);

parameter SIZE2 =12, SIZEKer2 = 3;
parameter STEP_MAX_POOLING2 = 2;
parameter SIZEINPUT_POOLING2 = SIZE2 - SIZEKer2 + 1;
parameter SIZEPOOLING2 = 2,SIZEOUTCONV2 = (SIZEINPUT_POOLING2 - 2)/STEP_MAX_POOLING2 + 1;

logic done10;
logic done10m;
logic  signed  [WIDTH_BIT-1:0] Kernels2d_01 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] Kernels2d_02 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] Kernels2d_03 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] Kernels2d_04 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] Kernels2d_11 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] Kernels2d_12 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] Kernels2d_13 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] Kernels2d_14 [SIZEKer2-1:0][SIZEKer2-1:0];
logic  signed  [WIDTH_BIT-1:0] dense [100-1:0][10-1:0];

// logic signed  [WIDTH_BIT-1:0] convIxKernelOut_1_0     [FILTER_N2D-1:0][SIZE2-SIZEKer2:0][SIZE2-SIZEKer2:0]     ;

logic signed  [WIDTH_BIT-1:0] convIxKernelOut_F01     [SIZE2-SIZEKer2:0][SIZE2-SIZEKer2:0]     ;
logic signed  [WIDTH_BIT-1:0] convIxKernelOut_F02     [SIZE2-SIZEKer2:0][SIZE2-SIZEKer2:0]     ;
logic signed  [WIDTH_BIT-1:0] convIxKernelOut_F03     [SIZE2-SIZEKer2:0][SIZE2-SIZEKer2:0]     ;
logic signed  [WIDTH_BIT-1:0] convIxKernelOut_F04     [SIZE2-SIZEKer2:0][SIZE2-SIZEKer2:0]     ;


logic signed  [WIDTH_BIT-1:0] convIxKernelOut_0_uni     [SIZE2-SIZEKer2:0][SIZE2-SIZEKer2:0]     ;
logic signed  [WIDTH_BIT-1:0] convIxKernelOut_0_un1     [SIZE2-SIZEKer2:0][SIZE2-SIZEKer2:0]     ;

logic signed  [WIDTH_BIT-1:0] maxPoolingOutF1      [SIZEOUTCONV2-1:0][SIZEOUTCONV2-1:0]   ;
logic signed  [WIDTH_BIT-1:0] maxPoolingOutF2      [SIZEOUTCONV2-1:0][SIZEOUTCONV2-1:0]   ;
logic signed  [WIDTH_BIT-1:0] maxPoolingOutF3      [SIZEOUTCONV2-1:0][SIZEOUTCONV2-1:0]   ;
logic signed  [WIDTH_BIT-1:0] maxPoolingOutF4      [SIZEOUTCONV2-1:0][SIZEOUTCONV2-1:0]   ;
logic signed  [WIDTH_BIT-1:0]bias0_2;
logic signed  [WIDTH_BIT-1:0]bias1_2;
logic signed  [WIDTH_BIT-1:0]bias2_2;
logic signed  [WIDTH_BIT-1:0]bias3_2;

logic signed  [WIDTH_BIT-1:0]bias2 [FILTER_N2D-1:0];
logic signed  [WIDTH_BIT-1:0]biasdense [10-1:0];

assign bias0_2 = bias2[0];
assign bias1_2 = bias2[1];
assign bias2_2 = bias2[2];
assign bias3_2 = bias2[3];


logic signed [WIDTH_BIT-1:0] flatten [SIZEOUTCONV2*SIZEOUTCONV2*4-1:0];
logic signed [WIDTH_BIT-1:0] denseout [10-1:0];

conv2D #(.SIZE(SIZE2),.SIZEKer(SIZEKer2),.WIDTH_BIT(WIDTH_BIT)) conv00 (
            .clock                           (clock                          )                               ,
            .nreset                          (nreset3                        )                               ,
            .inpMatrixI1                     (maxPoolingOut0                 )                               ,
            .inpMatrixI2                     (maxPoolingOut1                 )                               ,
            .Kernel1                         (Kernels2d_01                   )                               ,
            .Kernel2                         (Kernels2d_11                   )                               ,
            .done                            (done10                         )                               ,
            .convIxKernelOut                 (convIxKernelOut_F01            ),
            .bias(bias0_2)
);

conv2D #(.SIZE(SIZE2),.SIZEKer(SIZEKer2),.WIDTH_BIT(WIDTH_BIT)) conv01 (
            .clock                           (clock                          )                               ,
            .nreset                          (nreset3                        )                               ,
            .inpMatrixI1                     (maxPoolingOut0                 )                               ,
            .inpMatrixI2                     (maxPoolingOut1                 )                               ,
            .Kernel1                         (Kernels2d_02                   )                               ,
            .Kernel2                         (Kernels2d_12                   )                               ,
            .done                            (                               )                               ,
            .convIxKernelOut                 (convIxKernelOut_F02            ),
            .bias(bias1_2)
);

conv2D #(.SIZE(SIZE2),.SIZEKer(SIZEKer2),.WIDTH_BIT(WIDTH_BIT)) conv02 (
            .clock                           (clock                          )                               ,
            .nreset                          (nreset3                        )                               ,
            .inpMatrixI1                     (maxPoolingOut0                 )                               ,
            .inpMatrixI2                     (maxPoolingOut1                 )                               ,
            .Kernel1                         (Kernels2d_03                   )                               ,
            .Kernel2                         (Kernels2d_13                   )                               ,
            .done                            (                               )                               ,
            .convIxKernelOut                 (convIxKernelOut_F03            ),
            .bias(bias2_2)
);

conv2D #(.SIZE(SIZE2),.SIZEKer(SIZEKer2),.WIDTH_BIT(WIDTH_BIT)) conv03 (
            .clock                           (clock                          )                               ,
            .nreset                          (nreset3                        )                               ,
            .inpMatrixI1                     (maxPoolingOut0                 )                               ,
            .inpMatrixI2                     (maxPoolingOut1                 )                               ,
            .Kernel1                         (Kernels2d_04                   )                               ,
            .Kernel2                         (Kernels2d_14                   )                               ,
            .done                            (                               )                               ,
            .convIxKernelOut                 (convIxKernelOut_F04            ),
            .bias(bias3_2)
);

maxpooling #(.SIZE(SIZE2-SIZEKer2),.STEP_MAX_POOLING(STEP_MAX_POOLING2),.SIZEOUTCONV(SIZEOUTCONV2),.SIZEPOOLING(SIZEPOOLING2),.WIDTH_BIT(WIDTH_BIT)) maxPooling10 (
            .clock                              (clock                )                               ,
            .nreset                             (nreset4              )                               ,
            .convIxKernelOut                    ( convIxKernelOut_F01 )                               ,
            .done                               (done10m              )                               ,
            .maxPoolingOut                      (maxPoolingOutF1      )
);

maxpooling #(.SIZE(SIZE2-SIZEKer2),.STEP_MAX_POOLING(STEP_MAX_POOLING2),.SIZEOUTCONV(SIZEOUTCONV2),.SIZEPOOLING(SIZEPOOLING2),.WIDTH_BIT(WIDTH_BIT)) maxPooling11 (
            .clock                              (clock                )                               ,
            .nreset                             (nreset4              )                               ,
            .convIxKernelOut                    ( convIxKernelOut_F02 )                               ,
            .done                               (                     )                               ,
            .maxPoolingOut                      (maxPoolingOutF2      )
);

maxpooling #(.SIZE(SIZE2-SIZEKer2),.STEP_MAX_POOLING(STEP_MAX_POOLING2),.SIZEOUTCONV(SIZEOUTCONV2),.SIZEPOOLING(SIZEPOOLING2),.WIDTH_BIT(WIDTH_BIT)) maxPooling12 (
            .clock                              (clock                )                               ,
            .nreset                             (nreset4              )                               ,
            .convIxKernelOut                    ( convIxKernelOut_F03 )                               ,
            .done                               (                     )                               ,
            .maxPoolingOut                      (maxPoolingOutF3      )
);
maxpooling #(.SIZE(SIZE2-SIZEKer2),.STEP_MAX_POOLING(STEP_MAX_POOLING2),.SIZEOUTCONV(SIZEOUTCONV2),.SIZEPOOLING(SIZEPOOLING2),.WIDTH_BIT(WIDTH_BIT)) maxPooling13 (
            .clock                              (clock                )                               ,
            .nreset                             (nreset4              )                               ,
            .convIxKernelOut                    ( convIxKernelOut_F04 )                               ,
            .done                               (                     )                               ,
            .maxPoolingOut                      (maxPoolingOutF4      )
);


flatten_mod #(.WIDTH_BIT(WIDTH_BIT),.SIZEOUTCONV2(SIZEOUTCONV2),.SIZEFLATTEN(4))flattenInst(
            .maxPoolingOutF1(maxPoolingOutF1)                            ,
            .maxPoolingOutF2(maxPoolingOutF2)                            ,
            .maxPoolingOutF3(maxPoolingOutF3)                            ,
            .maxPoolingOutF4(maxPoolingOutF4)                            ,
            .flattenOut     (flatten        )
);

assign bias0 = bias[0];
assign bias1 = bias[1];
initial begin
        $readmemh("simulation/I.txt",inpMatrixI);
        $readmemh("simulation/bias0.txt",bias);
        $readmemh("simulation/bias2.txt",bias2);
        $readmemh("simulation/bias5.txt",biasdense);
        $readmemh("simulation/Kernel00.txt",Kernel00);
        $readmemh("simulation/Kernel01.txt",Kernel01);
        $readmemh("simulation/danse.txt00.txt",dense);
        $readmemh("simulation/kernels2d_00.txt",Kernels2d_01);
        $readmemh("simulation/kernels2d_01.txt",Kernels2d_02);
        $readmemh("simulation/kernels2d_02.txt",Kernels2d_03);
        $readmemh("simulation/kernels2d_03.txt",Kernels2d_04);
        $readmemh("simulation/kernels2d_10.txt",Kernels2d_11);
        $readmemh("simulation/kernels2d_11.txt",Kernels2d_12);
        $readmemh("simulation/kernels2d_12.txt",Kernels2d_13);
        $readmemh("simulation/kernels2d_13.txt",Kernels2d_14);


        clock =0;
        nreset1 = 0;
        nreset2 = 0;
        nreset3 = 0;
        nreset4 = 0;
        #1 nreset1 = 1;
        timestart = $realtime();
        do begin 
            #1 clock = ~clock;
        end while(!done0);
        clock =0;
        nreset1 = 0;
        nreset2 = 1;
        nreset3 = 0;
        nreset4 = 0;
        do begin 
            #1 clock = ~clock;
        end while(!done0m);
        nreset1 = 0;
        nreset2 = 0;
        nreset3 = 1;
        nreset4 = 0;
        // convIxKernelOut1 

        $writememh("simulation/convIxKernelOut0.txt",convIxKernelOut0);
        $writememh("simulation/convIxKernelOut1.txt",convIxKernelOut1);
        $writememh("simulation/maxpooling0.txt",maxPoolingOut0);
        $writememh("simulation/maxpooling1.txt",maxPoolingOut1);

        do begin 
            #1 clock = ~clock;
        end while(!done10);
        $writememh("simulation/convIxKernelOut_F01.txt",convIxKernelOut_F01);
        $writememh("simulation/convIxKernelOut_F02.txt",convIxKernelOut_F02);
        $writememh("simulation/convIxKernelOut_F03.txt",convIxKernelOut_F03);
        $writememh("simulation/convIxKernelOut_F04.txt",convIxKernelOut_F04);

        nreset1 = 0;
        nreset2 = 0;
        nreset3 = 0;
        nreset4 = 1;
        do begin 
            #1 clock = ~clock;
        end while(!done10m);

        $writememh("simulation/maxpoolingF1.txt",maxPoolingOutF1);
        $writememh("simulation/maxpoolingF2.txt",maxPoolingOutF2);
        $writememh("simulation/maxpoolingF3.txt",maxPoolingOutF3);
        $writememh("simulation/maxpoolingF4.txt",maxPoolingOutF4);
        $writememh("simulation/convIxKernelOut_F03.txt",convIxKernelOut_F03);
        $display("Matriz Maxpooling0>> \n");


        $writememh("simulation/flatten.txt",flatten);
        $display("\n");
        $display("[");

        for(integer i = 0; i < 10; i++)begin
            sum = 0;
              for(integer k = 0;k < 100; k++)begin
                sum+=flatten[k]*dense[k][i]+biasdense[i];
              end
           denseout[i] = sum ;
           $display(i,sum);

        end
        $display("]");
        $display("\n");
        $writememh("simulation/dense.txt",denseout);
    end
endmodule
