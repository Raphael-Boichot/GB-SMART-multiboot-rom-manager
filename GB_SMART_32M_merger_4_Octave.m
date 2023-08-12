clc
clear
delete 'OUTPUT.GB'
dumb4Mo=255*ones(2^22,1);
%calculate all possible starting offsets for any rom into the multiboot
for k=1:1:127
pos32ko(k)=k*2^15+1;
end
for k=1:1:63
pos64ko(k)=k*2^16+1;
end
for k=1:1:31
pos128ko(k)=k*2^17+1;
end
for k=1:1:15
pos256ko(k)=k*2^18+1;
end
for k=1:1:7
pos512ko(k)=k*2^19+1;
end
for k=1:1:3
pos1024ko(k)=k*2^20+1;
end
for k=1:1:1
pos2048ko(k)=k*2^21+1;
end

listing = (dir('rom/*.gb*'));
% if length(listing)>15;
%     disp('The number of rom must be 15 or less !')
% end

bytes=0;
for i=1:1:length(listing)
    bytes=bytes+listing(i).bytes;
end
if bytes>2^22
    disp('The total size of roms is greater than 4MB !')
end

fid = fopen('CGBPACK.DAT','r');
while ~feof(fid)
a=fread(fid);
end
fclose(fid);
dumb4Mo(1:2^15)=a;%place the mandatory multiboot rom at the beginning
[heigth,p]=size(listing);
%sorting algorithm to ensure compatility Octave<->Matlab
for i=1:1:heigth
    for j=1:1:heigth-1
        if listing(j).bytes<listing(j+1).bytes
            list=listing(j);
            listing(j)=listing(j+1);
            listing(j+1)=list;
        end
    end
end

games=0;
%now place the files to the good offset, biggest first
for i=1:1:heigth
    rom_size=listing(i).bytes;
    %-------------------------------------------------------------------------
    if rom_size==2^21;
        if mean(dumb4Mo(pos2048ko(end):pos2048ko(end)+rom_size-1))==255;
            fid=['./rom/',char(listing(i).name)];;
            disp(['Slot available for ',fid])
            fid = fopen(fid,'r');
            while ~feof(fid)
                a=fread(fid);
            end
            fclose(fid);
            games=games+1;
            dumb4Mo(pos2048ko(end):pos2048ko(end)+rom_size-1)=a;
            disp('File added to the Multiboot rom')
            %now disable any adresses in this range
            pos1024ko = pos1024ko(pos1024ko < pos2048ko(end));
            pos512ko = pos512ko(pos512ko < pos2048ko(end));
            pos256ko = pos256ko(pos256ko < pos2048ko(end));
            pos128ko = pos128ko(pos128ko < pos2048ko(end));
            pos64ko = pos64ko(pos64ko < pos2048ko(end));
            pos32ko = pos32ko(pos32ko < pos2048ko(end));
        else
            fid=char(listing(i).name);
            disp(['Slot FULL for ',fid,': file rejected !'])
        end
    end
    %-------------------------------------------------------------------------
    if rom_size==2^20;
        if not(isempty(pos1024ko));
            if mean(dumb4Mo(pos1024ko(end):pos1024ko(end)+rom_size-1))==255
                fid=['./rom/',char(listing(i).name)];;
                disp(['Slot available for ',fid])
                fid = fopen(fid,'r');
                while ~feof(fid)
                    a=fread(fid);
                end
                fclose(fid);
                games=games+1;
                dumb4Mo(pos1024ko(end):pos1024ko(end)+rom_size-1)=a;
                disp('File added to the Multiboot rom')
                %now disable any adresses higher than this range
                pos512ko = pos512ko(pos512ko < pos1024ko(end));
                pos256ko = pos256ko(pos256ko < pos1024ko(end));
                pos128ko = pos128ko(pos128ko < pos1024ko(end));
                pos64ko = pos64ko(pos64ko < pos1024ko(end));
                pos32ko = pos32ko(pos32ko < pos1024ko(end));
                %disable itself
                pos1024ko=pos1024ko(1:end-1);
            end
        else
            fid=char(listing(i).name);
            disp(['Slot FULL for ',fid,': file rejected !'])
        end
    end
    %-------------------------------------------------------------------------
    if rom_size==2^19;
        if not(isempty(pos512ko));
            if mean(dumb4Mo(pos512ko(end):pos512ko(end)+rom_size-1))==255
                fid=['./rom/',char(listing(i).name)];
                disp(['Slot available for ',fid])
                fid = fopen(fid,'r');
                while ~feof(fid)
                    a=fread(fid);
                end
                fclose(fid);
                games=games+1;
                dumb4Mo(pos512ko(end):pos512ko(end)+rom_size-1)=a;
                disp('File added to the Multiboot rom')
                %now disable any adresses higher than this range
                pos256ko = pos256ko(pos256ko < pos512ko(end));
                pos128ko = pos128ko(pos128ko < pos512ko(end));
                pos64ko = pos64ko(pos64ko < pos512ko(end));
                pos32ko = pos32ko(pos32ko < pos512ko(end));
                %disable itself
                pos512ko=pos512ko(1:end-1);
            end
        else
            fid=char(listing(i).name);
            disp(['Slot FULL for ',fid,': file rejected !'])
        end
    end
    %-------------------------------------------------------------------------
    if rom_size==2^18;
        if not(isempty(pos256ko));
            if mean(dumb4Mo(pos256ko(end):pos256ko(end)+rom_size-1))==255
                fid=['./rom/',char(listing(i).name)];
                disp(['Slot available for ',fid])
                fid = fopen(fid,'r');
                while ~feof(fid)
                    a=fread(fid);
                end
                fclose(fid);
                games=games+1;
                dumb4Mo(pos256ko(end):pos256ko(end)+rom_size-1)=a;
                disp('File added to the Multiboot rom')
                %now disable any adresses higher than this range
                pos128ko = pos128ko(pos128ko < pos256ko(end));
                pos64ko = pos64ko(pos64ko < pos256ko(end));
                pos32ko = pos32ko(pos32ko < pos256ko(end));
                %disable itself
                pos256ko=pos256ko(1:end-1);
            end
        else
            fid=char(listing(i).name);
            disp(['Slot FULL for ',fid,': file rejected !'])
        end
    end
    %-------------------------------------------------------------------------
    if rom_size==2^17;
        if not(isempty(pos128ko));
            if mean(dumb4Mo(pos128ko(end):pos128ko(end)+rom_size-1))==255
                fid=['./rom/',char(listing(i).name)];
                disp(['Slot available for ',fid])
                fid = fopen(fid,'r');
                while ~feof(fid)
                    a=fread(fid);
                end
                fclose(fid);
                games=games+1;
                dumb4Mo(pos128ko(end):pos128ko(end)+rom_size-1)=a;
                disp('File added to the Multiboot rom')
                %now disable any adresses higher than this range
                pos64ko = pos64ko(pos64ko < pos128ko(end));
                pos32ko = pos32ko(pos32ko < pos128ko(end));
                %disable itself
                pos128ko=pos128ko(1:end-1);
            end
        else
            fid=char(listing(i).name);
            disp(['Slot FULL for ',fid,': file rejected !'])
        end
    end
    %-------------------------------------------------------------------------
    if rom_size==2^16;
        if not(isempty(pos64ko));
            if mean(dumb4Mo(pos64ko(end):pos64ko(end)+rom_size-1))==255
                fid=['./rom/',char(listing(i).name)];
                disp(['Slot available for ',fid])
                fid = fopen(fid,'r');
                while ~feof(fid)
                    a=fread(fid);
                end
                fclose(fid);
                games=games+1;
                dumb4Mo(pos64ko(end):pos64ko(end)+rom_size-1)=a;
                disp('File added to the Multiboot rom')
                %now disable any adresses higher than this range
                pos32ko = pos32ko(pos32ko < pos64ko(end));
                %disable itself
                pos64ko=pos64ko(1:end-1);
            end
        else
            fid=char(listing(i).name);
            disp(['Slot FULL for ',fid,': file rejected !'])
        end
    end
    %-------------------------------------------------------------------------
    if rom_size==2^15;
        if not(isempty(pos32ko));
            if mean(dumb4Mo(pos32ko(end):pos32ko(end)+rom_size-1))==255
                fid=['./rom/',char(listing(i).name)];
                disp(['Slot available for ',fid])
                fid = fopen(fid,'r');
                while ~feof(fid)
                    a=fread(fid);
                end
                fclose(fid);
                games=games+1;
                dumb4Mo(pos32ko(end):pos32ko(end)+rom_size-1)=a;
                disp('File added to the Multiboot rom')
                %disable itself
                pos32ko=pos32ko(1:end-1);
            end
        else
            fid=char(listing(i).name);
            disp(['Slot FULL for ',fid,': file rejected !'])
        end
    end
%     if games==15;
%         disp('Maximum number of games reached');
%         fid = fopen('OUTPUT.GB','w');
%         a=fwrite(fid,dumb4Mo);
%         fclose(fid);
%         disp('16M merged rom created, ready to burn !')
%         return;
%     end
end


fid = fopen('OUTPUT.GB','w');
a=fwrite(fid,dumb4Mo);
fclose(fid);
disp('32M merged rom created, ready to burn !')
