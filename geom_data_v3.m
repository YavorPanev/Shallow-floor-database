function geom_data=geom_data_v3(H,B,t_w,t_f,conc_t)

 %Define grid
   n_grid=0.002;
 
 %Calculate node coordinates
 node_cord=[];
 element_reg=[];
 bc_up=[];
 bc_down=[];
 node_all=[];
 
 count=1;
 count_el=1;
  
  %calculate bottom
 
 target_x=linspace(-B,B,2*B/n_grid+1);
 target_y=linspace(0, t_f, t_f/n_grid+1);
 

 for yy=1:length(target_y)
   for xx=1:length(target_x)
     node_cord(count,1)=count;
     node_cord(count,2)=target_x(xx);
     node_cord(count,3)=target_y(yy);
     node_cord(count,4)=0;
     node_cord(count,5)=0;
     node_cord(count,6)=0;
     count++;
   end
 end
  
  check_bottom=count-length(target_x)-2;
  
 %calculate web
 
 target_x=linspace(-t_w/2,t_w/2,t_w/n_grid+1);
 target_y=linspace(t_f+n_grid, H-conc_t-n_grid, (H-conc_t-2*n_grid)/n_grid+1);
 

 for yy=1:length(target_y)
   for xx=1:length(target_x)
     node_cord(count,1)=count;
     node_cord(count,2)=target_x(xx);
     node_cord(count,3)=target_y(yy);
     node_cord(count,4)=0;
     node_cord(count,5)=0;
     node_cord(count,6)=0;
     count++;
   end
 end
 
  check_web=count-length(target_x)-2;
  
  %Define top
 target_x=linspace(-B,B,2*B/n_grid+1);
 target_y=linspace(H-conc_t, H, conc_t/n_grid+1);
 

 for yy=1:length(target_y)
   for xx=1:length(target_x)
     node_cord(count,1)=count;
     node_cord(count,2)=target_x(xx);
     node_cord(count,3)=target_y(yy);
     node_cord(count,4)=0;
     node_cord(count,5)=0;
     node_cord(count,6)=0;
     count++;
   end
 end
 
check_top=count-length(target_x)-2;
 
 node_cord=repmat(node_cord,2,1);
 node_cord(count:size(node_cord,1),1)=count:size(node_cord,1);
 node_cord(count:size(node_cord,1),4)=n_grid;
 


%DEFINE ELEMENTS
%define bottom elements

for ii=1:check_bottom
  if node_cord(ii,2)!=B
    element_reg(count_el,1)=count_el;
    element_reg(count_el, 2)= 2;
    element_reg(count_el, 3)= node_cord(ii,1);
    element_reg(count_el, 4)= node_cord(ii+1,1);
    element_reg(count_el, 5)= node_cord(ii+length(target_x)+1,1);
    element_reg(count_el, 6)= node_cord(ii+length(target_x),1);
    element_reg(count_el, 7)= node_cord(ii+0.5*length(node_cord),1);
    element_reg(count_el, 8)= node_cord(ii+0.5*length(node_cord)+1,1);
    element_reg(count_el, 9)= node_cord(ii+0.5*length(node_cord)+length(target_x)+1,1);
    element_reg(count_el, 10)= node_cord(ii+0.5*length(node_cord)+length(target_x),1);
    
%Check BC

    bc_check_y=node_cord([element_reg(count_el,3:10)],3)';
    bc_check_x=node_cord([element_reg(count_el,3:10)],2)';
     
    if bc_check_y==[H-n_grid,H-n_grid,H,H,H-n_grid,H-n_grid,H,H]
      append=[element_reg(count_el,6),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,10)];
      bc_up=[bc_up; append];
      
    elseif bc_check_y==[0,0,n_grid,n_grid,0,0,n_grid,n_grid]
      append=[element_reg(count_el,3),element_reg(count_el,4),element_reg(count_el,8),element_reg(count_el,7)];
      bc_down=[bc_down; append];
      
    elseif bc_check_y==[t_f-n_grid,t_f-n_grid,t_f,t_f,t_f-n_grid,t_f-n_grid,t_f,t_f]&&(all(bc_check_x<=t_w/2) || all(bc_check_x>=t_w/2))
      append=[element_reg(count_el,6),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,10)];
      bc_down=[bc_down; append];
      
     elseif bc_check_y==[H-conc_t,H-conc_t,H-conc_t+n_grid,H-conc_t+n_grid,  H-conc_t,H-conc_t,H-conc_t+n_grid,H-conc_t+n_grid,]&&(all(bc_check_x<=t_w/2) || all(bc_check_x>=t_w/2))
      append=[element_reg(count_el,3),element_reg(count_el,4),element_reg(count_el,8),element_reg(count_el,7)];
      bc_down=[bc_down; append] ;
      
      end
     
    if bc_check_x==[-t_w/2,-t_w/2+n_grid,-t_w/2+n_grid,-t_w/2,-t_w/2,-t_w/2+n_grid,-t_w/2+n_grid,-t_w/2]&&(all(bc_check_y>=t_f) || all(bc_chrck_y<=H-conc_t))
        append=[element_reg(count_el,3),element_reg(count_el,7),element_reg(count_el,10),element_reg(count_el,6)];
        bc_down=[bc_down; append];
        
      elseif bc_check_x==[t_w/2-n_grid, t_w, t_w, t_w-n_grid, t_w/2-n_grid, t_w, t_w, t_w-n_grid]&&(all(bc_check_y>=t_f) || all(bc_chrck_y<=H-conc_t))
        append=[element_reg(count_el,4),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,8)];
        bc_down=[bc_down; append];
      
      elseif bc_check_x==[B/2-n_grid, B/2, B/2, B/2-n_grid, B/2-n_grid, B/2, B/2, B/2-n_grid]&&(all(bc_check_y>=0) || all(bc_chrck_y<=t_f))
        append=[element_reg(count_el,4),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,8)];
        bc_down=[bc_down; append];
        
      elseif bc_check_x==[-B/2,-B/2+n_grid,-B/2+n_grid,-B/2,-B/2,-B/2+n_grid,-B/2+n_grid,-B/2]&&(all(bc_check_y>=0) || all(bc_chrck_y<=t_f))
        append=[element_reg(count_el,3),element_reg(count_el,7),element_reg(count_el,10),element_reg(count_el,6)];
        bc_down=[bc_down; append];
        
      end    
    
    
    count_el++;
  end
  ii++;
end

%Web Elements

ii=check_bottom+length(target_x)+2;
target_x=linspace(-t_w/2,t_w/2,t_w/n_grid+1);

for ii=ii:check_web
  if node_cord(ii,2)!=t_w/2
    element_reg(count_el,1)=count_el;
    element_reg(count_el, 2)= 2;
    element_reg(count_el, 3)= node_cord(ii,1);
    element_reg(count_el, 4)= node_cord(ii+1,1);
    element_reg(count_el, 5)= node_cord(ii+length(target_x)+1,1);
    element_reg(count_el, 6)= node_cord(ii+length(target_x),1);
    element_reg(count_el, 7)= node_cord(ii+0.5*length(node_cord),1);
    element_reg(count_el, 8)= node_cord(ii+0.5*length(node_cord)+1,1);
    element_reg(count_el, 9)= node_cord(ii+0.5*length(node_cord)+length(target_x)+1,1);
    element_reg(count_el, 10)= node_cord(ii+0.5*length(node_cord)+length(target_x),1);
    
    %Check BC

    bc_check_y=node_cord([element_reg(count_el,3:10)],3)';
    bc_check_x=node_cord([element_reg(count_el,3:10)],2)';
     
    if bc_check_y==[H-n_grid,H-n_grid,H,H,H-n_grid,H-n_grid,H,H]
      append=[element_reg(count_el,6),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,10)];
      bc_up=[bc_up; append];
      
    elseif bc_check_y==[0,0,n_grid,n_grid,0,0,n_grid,n_grid]
      append=[element_reg(count_el,3),element_reg(count_el,4),element_reg(count_el,8),element_reg(count_el,7)];
      bc_down=[bc_down; append];
      
    elseif bc_check_y==[t_f-n_grid,t_f-n_grid,t_f,t_f,t_f-n_grid,t_f-n_grid,t_f,t_f]&&(all(bc_check_x<=t_w/2) || all(bc_check_x>=t_w/2))
      append=[element_reg(count_el,6),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,10)];
      bc_down=[bc_down; append];
      
     elseif bc_check_y==[H-conc_t,H-conc_t,H-conc_t+n_grid,H-conc_t+n_grid,  H-conc_t,H-conc_t,H-conc_t+n_grid,H-conc_t+n_grid,]&&(all(bc_check_x<=t_w/2) || all(bc_check_x>=t_w/2))
      append=[element_reg(count_el,3),element_reg(count_el,4),element_reg(count_el,8),element_reg(count_el,7)];
      bc_down=[bc_down; append] ;
      
     end
     
    if bc_check_x==[-t_w/2,-t_w/2+n_grid,-t_w/2+n_grid,-t_w/2,-t_w/2,-t_w/2+n_grid,-t_w/2+n_grid,-t_w/2]&&(all(bc_check_y>=t_f) || all(bc_chrck_y<=H-conc_t))
        append=[element_reg(count_el,3),element_reg(count_el,7),element_reg(count_el,10),element_reg(count_el,6)];
        bc_down=[bc_down; append];
        
      elseif bc_check_x==[t_w/2-n_grid, t_w, t_w, t_w-n_grid, t_w/2-n_grid, t_w, t_w, t_w-n_grid]&&(all(bc_check_y>=t_f) || all(bc_chrck_y<=H-conc_t))
        append=[element_reg(count_el,4),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,8)];
        bc_down=[bc_down; append];
      
      elseif bc_check_x==[B/2-n_grid, B/2, B/2, B/2-n_grid, B/2-n_grid, B/2, B/2, B/2-n_grid]&&(all(bc_check_y>=0) || all(bc_chrck_y<=t_f))
        append=[element_reg(count_el,4),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,8)];
        bc_down=[bc_down; append];
        
      elseif bc_check_x==[-B/2,-B/2+n_grid,-B/2+n_grid,-B/2,-B/2,-B/2+n_grid,-B/2+n_grid,-B/2]&&(all(bc_check_y>=0) || all(bc_chrck_y<=t_f))
        append=[element_reg(count_el,3),element_reg(count_el,7),element_reg(count_el,10),element_reg(count_el,6)];
        bc_down=[bc_down; append];
        
      end        
    
    
    
    count_el++;
  end
  ii++;
end

%Define top elements
    
ii=check_web+length(target_x)+2;
target_x=linspace(-B,B,2*B/n_grid+1);


for ii=ii:check_top
  if node_cord(ii,2)!=B/2
    
    element_reg(count_el,1)=count_el;
    element_reg(count_el, 3)= node_cord(ii,1);
    element_reg(count_el, 4)= node_cord(ii+1,1);
    element_reg(count_el, 5)= node_cord(ii+length(target_x)+1,1);
    element_reg(count_el, 6)= node_cord(ii+length(target_x),1);
    element_reg(count_el, 7)= node_cord(ii+0.5*length(node_cord),1);
    element_reg(count_el, 8)= node_cord(ii+0.5*length(node_cord)+1,1);
    element_reg(count_el, 9)= node_cord(ii+0.5*length(node_cord)+length(target_x)+1,1);
    element_reg(count_el, 10)= node_cord(ii+0.5*length(node_cord)+length(target_x),1);
    
    %Check part
    
    el_centre=[0.25*(node_cord(ii,2)+node_cord(ii+1,2)+node_cord(ii+length(target_x)+1,2)+node_cord(ii+length(target_x),2)), 0.25*(node_cord(ii,3)+node_cord(ii+1,3)+node_cord(ii+length(target_x)+1,3)+node_cord(ii+length(target_x),3))];
    
    if el_centre(1)>-B/2 && el_centre(1)<B/2 && el_centre(2)<H && el_centre(2)>H-t_f
      
      element_reg(count_el,2)=2;
      
    elseif el_centre(1)>-t_w/2 && el_centre(1)<t_w/2 && el_centre(2)<H-t_f && el_centre(2)>H-conc_t
      element_reg(count_el,2)=2;
      
    else
      element_reg(count_el,2)=1;
    end
    
    
   
    
    %Checl BC
    
    bc_check_y=node_cord([element_reg(count_el,3:10)],3)';
    bc_check_x=node_cord([element_reg(count_el,3:10)],2)';
    
    if bc_check_y==[H-n_grid,H-n_grid,H,H,H-n_grid,H-n_grid,H,H]
      append=[element_reg(count_el,6),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,10)];
      bc_up=[bc_up; append];
      
    elseif bc_check_y==[0,0,n_grid,n_grid,0,0,n_grid,n_grid]
      append=[element_reg(count_el,3),element_reg(count_el,4),element_reg(count_el,8),element_reg(count_el,7)];
      bc_down=[bc_down; append];
      
    elseif bc_check_y==[t_f-n_grid,t_f-n_grid,t_f,t_f,t_f-n_grid,t_f-n_grid,t_f,t_f]&&(all(bc_check_x<=t_w/2) || all(bc_check_x>=t_w/2))
      append=[element_reg(count_el,6),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,10)];
      bc_down=[bc_down; append];
      
     elseif bc_check_y==[H-conc_t,H-conc_t,H-conc_t+n_grid,H-conc_t+n_grid,  H-conc_t,H-conc_t,H-conc_t+n_grid,H-conc_t+n_grid,]&&(all(bc_check_x<=t_w/2) || all(bc_check_x>=t_w/2))
      append=[element_reg(count_el,3),element_reg(count_el,4),element_reg(count_el,8),element_reg(count_el,7)];
      bc_down=[bc_down; append] ;
      
     end
     
    if bc_check_x==[-t_w/2,-t_w/2+n_grid,-t_w/2+n_grid,-t_w/2,-t_w/2,-t_w/2+n_grid,-t_w/2+n_grid,-t_w/2]&&(all(bc_check_y>=t_f) || all(bc_chrck_y<=H-conc_t))
        append=[element_reg(count_el,3),element_reg(count_el,7),element_reg(count_el,10),element_reg(count_el,6)];
        bc_down=[bc_down; append];
        
      elseif bc_check_x==[t_w/2-n_grid, t_w, t_w, t_w-n_grid, t_w/2-n_grid, t_w, t_w, t_w-n_grid]&&(all(bc_check_y>=t_f) || all(bc_chrck_y<=H-conc_t))
        append=[element_reg(count_el,4),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,8)];
        bc_down=[bc_down; append];
      
      elseif bc_check_x==[B/2-n_grid, B/2, B/2, B/2-n_grid, B/2-n_grid, B/2, B/2, B/2-n_grid]&&(all(bc_check_y>=0) || all(bc_chrck_y<=t_f))
        append=[element_reg(count_el,4),element_reg(count_el,5),element_reg(count_el,9),element_reg(count_el,8)];
        bc_down=[bc_down; append];
        
      elseif bc_check_x==[-B/2,-B/2+n_grid,-B/2+n_grid,-B/2,-B/2,-B/2+n_grid,-B/2+n_grid,-B/2]&&(all(bc_check_y>=0) || all(bc_chrck_y<=t_f))
        append=[element_reg(count_el,3),element_reg(count_el,7),element_reg(count_el,10),element_reg(count_el,6)];
        bc_down=[bc_down; append];
        
      end           

    
   
    count_el++;
    end
  ii++;
end

node_all=reshape(node_cord(:,1),[],2);
geom_data=struct("nodes", node_cord, "elements", element_reg, "bc_up", bc_up, "bc_down", bc_down, "node_all", node_all);




endfunction


