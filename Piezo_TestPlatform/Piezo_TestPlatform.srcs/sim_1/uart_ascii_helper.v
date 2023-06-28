
task send_ascii_A;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_B;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_C;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_D;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_E;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_F;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_G;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_H;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_I;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_J;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_K;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_L;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_M;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_N;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_O;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_P;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_Q;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_R;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_S;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_T;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_U;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_V;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_W;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_X;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_Y;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_Z;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_colon;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_space;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_lf;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_0;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_1;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_2;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_3;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_4;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_5;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_6;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_7;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_8;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask

task send_ascii_9;
    begin
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
        
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 1;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 0;
        #(10*PERIOD); uart_rx = 1;
    end
endtask