function write_file_v2
  tic;
  
  %Define parameters
  conc_t=0.2;
  t_f=0.01;
  t_w=0.008;
  B=0.16;
  H=0.4;
  
  name_B=B*1000;
  name_H=H*1000;
  name_C=conc_t*1000;
  
  %Define name
  
  name_file=sprintf('%d_%d_%d',name_H,name_B,name_C);
  mkdir(name_file);
  file_path=sprintf('./%s/',name_file);
  
  %calculate mesh
  
   A=geom_data_v3(H,B,t_w,t_f,conc_t);
  
  
  %Start writing file
  
  fileID = fopen([file_path,name_file,'.key'],'w');
  
  fprintf(fileID,'%s\r\n','*KEYWORD');
  
  fprintf(fileID,'%s\r\n','*NODE');
  for ii = 1:length(A.nodes)
    fprintf(fileID, '%d,%4.3f,%4.3f,%4.3f,%d,%d\r\n', A.nodes(ii,:));
  end
  
  fprintf(fileID,'%s\r\n','$');
  fprintf(fileID,'%s\r\n','*ELEMENT');
    for ii = 1:length(A.elements)
    fprintf(fileID, '%0.f,%0.f,%0.f,%0.f,%0.f,%0.f,%0.f,%0.f,%0.f,%0.f\r\n', A.elements(ii,:));
  end
  
  fprintf(fileID,'%s\r\n','$');
  fprintf(fileID,'%s\r\n','*SET_SEGMENT_TITLE');
  fprintf(fileID,'%s\r\n','bc_up');
  fprintf(fileID,'%s\r\n','1,0.0,0.0,0.0,0.0');
  
  for ii = 1:length(A.bc_up)
    fprintf(fileID, '%0.f,%0.f,%0.f,%0.f\r\n', A.bc_up(ii,:));
  end
  
  fprintf(fileID,'%s\r\n','$');
  fprintf(fileID,'%s\r\n','*SET_SEGMENT_TITLE');
  fprintf(fileID,'%s\r\n','bc_down');
  fprintf(fileID,'%s\r\n','2,0.0,0.0,0.0,0.0');
  for ii = 1:length(A.bc_down)
    fprintf(fileID, '%0.f,%0.f,%0.f,%0.f\r\n', A.bc_down(ii,:));
  end
  
  fprintf(fileID,'%s\r\n','$');
  
  copyf = fopen('core.txt', 'rt');
      while feof(copyf) == 0
          tline = fgetl(copyf);
          fwrite(fileID, sprintf('%s\n',tline ));
      end
           
  fclose(copyf);  
  fclose(fileID);
  
time_sol=toc;  
printf('Solution time for %s: %3.1f s', name_file, time_sol);
 endfunction
