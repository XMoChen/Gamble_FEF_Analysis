function [x_fp1,x_fp2,y_fp1,y_fp2]=DirectionOrg(v_x_fp,v_y_fp,Direct)
     if Direct==1
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
     elseif Direct==2
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
    
     elseif Direct==3
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
     elseif Direct==4
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);
    
     elseif  Direct==5
    x_fp1=v_x_fp(5);
    y_fp1=v_y_fp(5);
    
    x_fp2=v_x_fp(5);
    y_fp2=v_y_fp(5);
    
     elseif Direct==6
    x_fp1=v_x_fp(3);
    y_fp1=v_y_fp(3);
    
    x_fp2=v_x_fp(4);
    y_fp2=v_y_fp(4);  

    
     elseif Direct==7
    x_fp1=v_x_fp(2);
    y_fp1=v_y_fp(2);
    
    x_fp2=v_x_fp(3);
    y_fp2=v_y_fp(3);  
    

     elseif Direct==8
    x_fp1=v_x_fp(4);
    y_fp1=v_y_fp(4);
    
    x_fp2=v_x_fp(2);
    y_fp2=v_y_fp(2);  

     end
end